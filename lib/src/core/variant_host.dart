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
    }
  }

  Future<void> _load() async {
    final version = ++_loadVersion;

    if (widget.cache) {
      final cachedValues = VariantValuesMemoryCache.get(widget.url);

      if (cachedValues != null) {
        setState(() {
          _values = cachedValues;
        });
      }
    }

    final VariantLoadResult result;

    try {
      var pending = widget.loader(widget.url);
      final timeout = widget.timeout;

      if (timeout != null) {
        pending = pending.timeout(timeout);
      }

      result = await pending;
    } catch (error, stackTrace) {
      if (mounted && version == _loadVersion) {
        widget.onLoadError?.call(error, stackTrace);
      }

      return;
    }

    if (!mounted || version != _loadVersion) {
      return;
    }

    for (final issue in result.issues) {
      widget.onInvalidEntry?.call(issue);
    }

    if (widget.cache) {
      VariantValuesMemoryCache.set(widget.url, result.values);
    }

    widget.onLoaded?.call(result.values);

    setState(() {
      _values = result.values;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VariantScope(values: _values, child: widget.child);
  }
}
