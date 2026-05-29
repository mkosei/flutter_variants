import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantVisibility extends StatelessWidget {
  final String id;
  final bool fallback;
  final Widget child;
  final Widget replacement;

  const VariantVisibility({
    super.key,
    required this.id,
    required this.fallback,
    required this.child,
    this.replacement = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    final value = VariantScope.maybeValueOf(context, id);
    final variantValue = value?['value'];

    final visible = value?['type'] == 'bool' && variantValue is bool
        ? variantValue
        : fallback;

    return visible ? child : replacement;
  }
}
