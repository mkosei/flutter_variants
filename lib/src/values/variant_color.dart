import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantColor {
  const VariantColor._();

  static Color of(
    BuildContext context, {
    required String id,
    required Color fallback,
  }) {
    final value = VariantScope.maybeValueOf(context, id);
    final variantValue = value?['value'];

    if (value?['type'] != 'color' || variantValue is! String) {
      return fallback;
    }

    return _parseHexColor(variantValue) ?? fallback;
  }

  static Color? _parseHexColor(String value) {
    final normalized = value.trim();
    if (!normalized.startsWith('#')) {
      return null;
    }
    final hex = normalized.substring(1);
    if (hex.length == 6) {
      final rgb = int.tryParse(hex, radix: 16);
      if (rgb == null) return null;

      return Color(0xFF000000 | rgb);
    }
    if (hex.length == 8) {
      final argb = int.tryParse(hex, radix: 16);
      if (argb == null) return null;

      return Color(argb);
    }
    return null;
  }
}
