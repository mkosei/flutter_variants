import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantBorderRadius {
  const VariantBorderRadius._();

  static BorderRadius of(
    BuildContext context, {
    required String id,
    required BorderRadius fallback,
  }) {
    final value = VariantScope.maybeValueOf(context, id);

    if (value?['type'] != 'borderRadius') {
      return fallback;
    }

    final variantValue = value?['value'];

    if (variantValue is num) {
      return BorderRadius.circular(variantValue.toDouble());
    }

    if (variantValue is Map) {
      return BorderRadius.only(
        topLeft: _readCorner(variantValue, 'topLeft'),
        topRight: _readCorner(variantValue, 'topRight'),
        bottomLeft: _readCorner(variantValue, 'bottomLeft'),
        bottomRight: _readCorner(variantValue, 'bottomRight'),
      );
    }

    return fallback;
  }

  static Radius _readCorner(Map value, String key) {
    final corner = value[key];

    return corner is num ? Radius.circular(corner.toDouble()) : Radius.zero;
  }
}
