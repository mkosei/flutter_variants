import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantIcon extends StatelessWidget {
  final String id;
  final IconData fallback;
  final Map<String, IconData> approvedIcons;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  const VariantIcon({
    super.key,
    required this.id,
    required this.fallback,
    required this.approvedIcons,
    this.size,
    this.color,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final value = VariantScope.maybeValueOf(context, id);
    final variantValue = value?['value'];
    final identifier = value?['type'] == 'icon' && variantValue is String
        ? variantValue
        : null;

    final icon = identifier != null && approvedIcons.containsKey(identifier)
        ? approvedIcons[identifier]!
        : fallback;

    return Icon(
      icon,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}
