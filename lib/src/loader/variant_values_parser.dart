Map<String, Map<String, dynamic>> parseVariantValues(Object? json) {
  return parseVariantValuesWithIssues(json).values;
}

VariantParseResult parseVariantValuesWithIssues(Object? json) {
  if (json is! Map) {
    return VariantParseResult(
      values: const {},
      issues: [
        VariantParseIssue(
          code: VariantParseIssueCode.invalidRoot,
          message: 'Expected the root value to be a map.',
        ),
      ],
    );
  }

  final values = <String, Map<String, dynamic>>{};
  final issues = <VariantParseIssue>[];

  for (final entry in json.entries) {
    final key = entry.key;
    final value = entry.value;

    if (key is! String) {
      issues.add(
        VariantParseIssue(
          code: VariantParseIssueCode.invalidId,
          id: key,
          message: 'Expected the variant id to be a string.',
        ),
      );

      continue;
    }

    if (value is! Map) {
      issues.add(
        VariantParseIssue(
          code: VariantParseIssueCode.invalidValue,
          id: key,
          message: 'Expected the variant value to be a map.',
        ),
      );

      continue;
    }

    final type = value['type'];
    if (!value.containsKey('type')) {
      issues.add(
        VariantParseIssue(
          code: VariantParseIssueCode.missingType,
          id: key,
          message: 'Expected the variant value to include a type.',
        ),
      );

      continue;
    }

    if (type is! String) {
      issues.add(
        VariantParseIssue(
          code: VariantParseIssueCode.invalidType,
          id: key,
          message: 'Expected the variant type to be a string.',
        ),
      );

      continue;
    }

    if (value.keys.any((fieldKey) => fieldKey is! String)) {
      issues.add(
        VariantParseIssue(
          code: VariantParseIssueCode.invalidFieldKey,
          id: key,
          message: 'Expected all variant value field keys to be strings.',
        ),
      );

      continue;
    }

    values[key] = Map<String, dynamic>.from(value);
  }

  return VariantParseResult(values: values, issues: issues);
}

class VariantParseResult {
  final Map<String, Map<String, dynamic>> values;
  final List<VariantParseIssue> issues;

  const VariantParseResult({required this.values, required this.issues});
}

class VariantParseIssue {
  final VariantParseIssueCode code;
  final Object? id;
  final String message;

  const VariantParseIssue({required this.code, required this.message, this.id});
}

enum VariantParseIssueCode {
  invalidRoot,
  invalidId,
  invalidValue,
  missingType,
  invalidType,
  invalidFieldKey,
}
