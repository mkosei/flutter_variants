import 'package:flutter/widgets.dart';

import '../core/variant_scope.dart';

class VariantString {
  const VariantString._();

  static String of(
    BuildContext context, {
    required String id,
    required String fallback,
  }) {
    final value = VariantScope.maybeValueOf(context, id);
    final variantValue = value?['value'];

    if (value?['type'] != 'string' || variantValue is! String) {
      return fallback;
    }

    return variantValue;
  }
}
