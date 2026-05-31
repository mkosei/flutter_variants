import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantBool {
  const VariantBool._();

  static bool of(
    BuildContext context, {
    required String id,
    required bool fallback,
  }) {
    final value = VariantScope.maybeValueOf(context, id);
    final variantValue = value?['value'];

    if (value?['type'] != 'bool' || variantValue is! bool) {
      return fallback;
    }

    return variantValue;
  }
}
