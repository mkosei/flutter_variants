import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantText extends StatelessWidget {
  final String id;
  final String fallback;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const VariantText({
    super.key,
    required this.id,
    required this.fallback,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final value = VariantScope.maybeValueOf(context, id);
    final variantValue = value?['value'];
    final text = value?['type'] == 'text' && variantValue is String
        ? variantValue
        : null;

    return Text(
      text ?? fallback,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
