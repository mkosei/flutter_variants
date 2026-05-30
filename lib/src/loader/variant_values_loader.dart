import 'dart:convert';

import 'package:flutter/services.dart';

import 'variant_values_parser.dart';

typedef VariantValues = Map<String, Map<String, dynamic>>;

Future<VariantValues> loadVariantValuesFromUrl(Uri url) async {
  try {
    final responseBody = await NetworkAssetBundle(url).loadString('');
    final decoded = jsonDecode(responseBody);
    return parseVariantValues(decoded);
  } catch (_) {
    return const {};
  }
}
