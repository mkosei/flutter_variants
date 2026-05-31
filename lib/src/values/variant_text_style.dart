import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantTextStyle {
  const VariantTextStyle._();

  static TextStyle of(
    BuildContext context, {
    required String id,
    required TextStyle fallback,
  }) {
    final value = VariantScope.maybeValueOf(context, id);

    if (value?['type'] != 'textStyle') {
      return fallback;
    }

    final variantValue = value?['value'];
    if (variantValue is! Map) {
      return fallback;
    }

    return fallback.copyWith(
      fontSize: _readDouble(variantValue['fontSize']),
      fontWeight: _readFontWeight(variantValue['fontWeight']),
      color: _readColor(variantValue['color']),
      fontFamily: _readString(variantValue['fontFamily']),
      letterSpacing: _readDouble(variantValue['letterSpacing']),
      height: _readDouble(variantValue['height']),
      fontStyle: _readFontStyle(variantValue['fontStyle']),
    );
  }

  static double? _readDouble(Object? raw) {
    return raw is num ? raw.toDouble() : null;
  }

  static String? _readString(Object? raw) {
    return raw is String ? raw : null;
  }

  static FontWeight? _readFontWeight(Object? raw) {
    if (raw is num) {
      switch (raw.toInt()) {
        case 100:
          return FontWeight.w100;
        case 200:
          return FontWeight.w200;
        case 300:
          return FontWeight.w300;
        case 400:
          return FontWeight.w400;
        case 500:
          return FontWeight.w500;
        case 600:
          return FontWeight.w600;
        case 700:
          return FontWeight.w700;
        case 800:
          return FontWeight.w800;
        case 900:
          return FontWeight.w900;
      }

      return null;
    }

    if (raw is String) {
      switch (raw) {
        case 'thin':
          return FontWeight.w100;
        case 'extraLight':
          return FontWeight.w200;
        case 'light':
          return FontWeight.w300;
        case 'normal':
        case 'regular':
          return FontWeight.w400;
        case 'medium':
          return FontWeight.w500;
        case 'semiBold':
          return FontWeight.w600;
        case 'bold':
          return FontWeight.w700;
        case 'extraBold':
          return FontWeight.w800;
        case 'black':
          return FontWeight.w900;
      }
    }

    return null;
  }

  static FontStyle? _readFontStyle(Object? raw) {
    if (raw is! String) {
      return null;
    }

    switch (raw) {
      case 'normal':
        return FontStyle.normal;
      case 'italic':
        return FontStyle.italic;
    }

    return null;
  }

  static Color? _readColor(Object? raw) {
    if (raw is! String) {
      return null;
    }

    final normalized = raw.trim();
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
