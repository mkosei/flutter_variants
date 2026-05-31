import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantNumber {
  const VariantNumber._();

  static num of(
    BuildContext context, {
    required String id,
    required num fallback,
    num? min,
    num? max,
  }) {
    final value = VariantScope.maybeValueOf(context, id);
    final variantValue = value?['value'];

    if (value?['type'] != 'number' || variantValue is! num) {
      return _clamp(fallback, min: min, max: max);
    }

    return _clamp(variantValue, min: min, max: max);
  }

  static num _clamp(num value, {required num? min, required num? max}) {
    if (min != null && value < min) {
      return min;
    }

    if (max != null && value > max) {
      return max;
    }

    return value;
  }
}
