import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantEdgeInsets {
  const VariantEdgeInsets._();

  static EdgeInsets of(
    BuildContext context, {
    required String id,
    required EdgeInsets fallback,
  }) {
    final value = VariantScope.maybeValueOf(context, id);

    if (value?['type'] != 'edgeInsets') {
      return fallback;
    }

    final variantValue = value?['value'];

    if (variantValue is num) {
      return EdgeInsets.all(variantValue.toDouble());
    }

    if (variantValue is Map) {
      return EdgeInsets.only(
        left: _readSide(variantValue, 'left'),
        top: _readSide(variantValue, 'top'),
        right: _readSide(variantValue, 'right'),
        bottom: _readSide(variantValue, 'bottom'),
      );
    }

    return fallback;
  }

  static double _readSide(Map value, String key) {
    final side = value[key];

    return side is num ? side.toDouble() : 0;
  }
}
