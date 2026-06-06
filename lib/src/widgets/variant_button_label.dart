import 'package:flutter/material.dart';

import 'variant_text.dart';

class VariantButtonLabel extends StatelessWidget {
  final String id;
  final String fallback;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const VariantButtonLabel({
    super.key,
    required this.id,
    required this.fallback,
    required this.onPressed,
    this.onLongPress,
    this.style,
    this.textStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style,
      child: VariantText(
        id: id,
        fallback: fallback,
        style: textStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
