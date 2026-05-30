Map<String, Map<String, dynamic>> parseVariantValues(Object? json) {
  if (json is! Map) {
    return const {};
  }

  final values = <String, Map<String, dynamic>>{};

  for (final entry in json.entries) {
    final key = entry.key;
    final value = entry.value;

    if (key is! String || value is! Map) {
      continue;
    }

    final type = value['type'];
    if (type is! String) {
      continue;
    }

    values[key] = Map<String, dynamic>.from(value);
  }

  return values;
}
