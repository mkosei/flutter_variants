import 'dart:async';

import 'package:flutter/widgets.dart';

import '../loader/variant_values_loader.dart';
import '../loader/variant_values_memory_cache.dart';
import '../loader/variant_values_parser.dart';
import 'variant_scope.dart';

typedef VariantHostLoader = Future<VariantLoadResult> Function(Uri url);
typedef VariantHostLoadedCallback = void Function(VariantValues values);
typedef VariantHostLoadErrorCallback =
    void Function(Object error, StackTrace stackTrace);
typedef VariantHostInvalidEntryCallback =
    void Function(VariantParseIssue issue);

class VariantHost extends StatefulWidget {
  final Uri url;
  final Widget child;
  final VariantValues initialValues;
  final VariantHostLoader loader;
  final bool cache;
  final Duration? timeout;
  final int maxRetries;
  final Duration retryBackoff;
  final Duration? refreshInterval;
  final VariantHostLoadedCallback? onLoaded;
  final VariantHostLoadErrorCallback? onLoadError;
  final VariantHostInvalidEntryCallback? onInvalidEntry;

  const VariantHost({
    super.key,
    required this.url,
    required this.child,
    this.initialValues = const {},
    this.loader = loadVariantValuesFromUrl,
    this.cache = true,
    this.timeout,
    this.maxRetries = 0,
    this.retryBackoff = const Duration(milliseconds: 200),
    this.refreshInterval,
    this.onLoaded,
    this.onLoadError,
    this.onInvalidEntry,
  });

  @override
  State<VariantHost> createState() => _VariantHostState();
}

class _VariantHostState extends State<VariantHost> {
  late VariantValues _values = widget.initialValues;
  int _loadVersion = 0;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(VariantHost oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.url != oldWidget.url || widget.loader != oldWidget.loader) {
      _load();
    } else if (widget.refreshInterval != oldWidget.refreshInterval) {
      _scheduleRefresh();
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    _refreshTimer?.cancel();
    final version = ++_loadVersion;

    if (widget.cache) {
      final cachedValues = VariantValuesMemoryCache.get(widget.url);

      if (cachedValues != null) {
        setState(() {
          _values = cachedValues;
        });
      }
    }

    var backoff = widget.retryBackoff;
    Object? lastError;
    StackTrace? lastStackTrace;
    VariantLoadResult? result;

    for (var attempt = 0; attempt <= widget.maxRetries; attempt++) {
      if (!mounted || version != _loadVersion) {
        return;
      }

      try {
        var pending = widget.loader(widget.url);
        final timeout = widget.timeout;

        if (timeout != null) {
          pending = pending.timeout(timeout);
        }

        result = await pending;
        break;
      } catch (error, stackTrace) {
        lastError = error;
        lastStackTrace = stackTrace;

        if (attempt == widget.maxRetries) {
          break;
        }

        await Future<void>.delayed(backoff);
        backoff *= 2;
      }
    }

    if (!mounted || version != _loadVersion) {
      return;
    }

    final loaded = result;

    if (loaded == null) {
      widget.onLoadError?.call(
        lastError ?? Exception('Variant load failed'),
        lastStackTrace ?? StackTrace.current,
      );
      _scheduleRefresh();
      return;
    }

    for (final issue in loaded.issues) {
      widget.onInvalidEntry?.call(issue);
    }

    if (widget.cache) {
      VariantValuesMemoryCache.set(widget.url, loaded.values);
    }

    widget.onLoaded?.call(loaded.values);

    setState(() {
      _values = loaded.values;
    });

    _scheduleRefresh();
  }

  void _scheduleRefresh() {
    _refreshTimer?.cancel();
    final interval = widget.refreshInterval;

    if (interval == null || !mounted) {
      return;
    }

    _refreshTimer = Timer(interval, _load);
  }

  @override
  Widget build(BuildContext context) {
    return VariantScope(values: _values, child: widget.child);
  }
}
