import 'package:flutter/widgets.dart';

import '../core/remote_variant_scope.dart';

class RemoteText extends StatelessWidget {
  final String id;
  final String fallback;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const RemoteText({
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
    final value = RemoteVariantScope.maybeValueOf(context, id);
    final remoteValue = value?['value'];
    final text = value?['type'] == 'text' && remoteValue is String
        ? remoteValue
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
