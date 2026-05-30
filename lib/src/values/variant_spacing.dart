import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantSpacing {
  const VariantSpacing._();

  static double of(
    BuildContext context, {
    required String id,
    required double fallback,
    double? min,
    double? max,
  }) {
    final value = VariantScope.maybeValueOf(context, id);
    final variantValue = value?['value'];

    if (value?['type'] != 'spacing' || variantValue is! num) {
      return _clamp(fallback, min: min, max: max);
    }

    return _clamp(variantValue.toDouble(), min: min, max: max);
  }

  static double _clamp(
    double value, {
    required double? min,
    required double? max,
  }) {
    if (min != null && value < min) {
      return min;
    }

    if (max != null && value > max) {
      return max;
    }

    return value;
  }
}
