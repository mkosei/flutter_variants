import 'package:flutter/widgets.dart';

import '../loader/variant_values_loader.dart';
import 'variant_scope.dart';

typedef VariantHostLoader = Future<VariantValues> Function(Uri url);

class VariantHost extends StatefulWidget {
  final Uri url;
  final Widget child;
  final VariantValues initialValues;
  final VariantHostLoader loader;

  const VariantHost({
    super.key,
    required this.url,
    required this.child,
    this.initialValues = const {},
    this.loader = loadVariantValuesFromUrl,
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
    final VariantValues values;

    try {
      values = await widget.loader(widget.url);
    } catch (_) {
      return;
    }

    if (!mounted || version != _loadVersion) {
      return;
    }

    setState(() {
      _values = values;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VariantScope(values: _values, child: widget.child);
  }
}
