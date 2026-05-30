import 'package:flutter/foundation.dart';

import 'variant_values_loader.dart';

class VariantValuesMemoryCache {
  static final Map<Uri, VariantValues> _valuesByUrl = {};

  static VariantValues? get(Uri url) {
    return _valuesByUrl[url];
  }

  static void set(Uri url, VariantValues values) {
    _valuesByUrl[url] = values;
  }

  @visibleForTesting
  static void clear() {
    _valuesByUrl.clear();
  }
}
