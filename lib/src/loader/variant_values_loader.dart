import 'dart:convert';

import 'package:flutter/services.dart';

import 'variant_values_parser.dart';

typedef VariantValues = Map<String, Map<String, dynamic>>;

Future<VariantLoadResult> loadVariantValuesFromUrl(Uri url) async {
  final responseBody = await NetworkAssetBundle(url).loadString('');
  final decoded = jsonDecode(responseBody);
  final result = parseVariantValuesWithIssues(decoded);

  return VariantLoadResult(values: result.values, issues: result.issues);
}

class VariantLoadResult {
  final VariantValues values;
  final List<VariantParseIssue> issues;

  const VariantLoadResult({required this.values, this.issues = const []});
}
