import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantImage extends StatelessWidget {
  final String id;
  final ImageProvider fallback;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final String? semanticLabel;

  const VariantImage({
    super.key,
    required this.id,
    required this.fallback,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final value = VariantScope.maybeValueOf(context, id);
    final image = resolveImage(value);

    return Image(
      image: image,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      semanticLabel: semanticLabel,
    );
  }

  @visibleForTesting
  ImageProvider resolveImage(Map<String, dynamic>? value) {
    final variantValue = value?['value'];
    final url = value?['type'] == 'image' && variantValue is String
        ? variantValue
        : null;

    return url != null ? NetworkImage(url) : fallback;
  }
}
