import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('parseVariantValues', () {
    test('returns an empty map when the root value is not a map', () {
      expect(parseVariantValues(null), isEmpty);
      expect(parseVariantValues('invalid'), isEmpty);
      expect(parseVariantValues([1, 2, 3]), isEmpty);
    });

    test('keeps entries with string ids, map values, and string types', () {
      final values = parseVariantValues({
        'home.title': {'type': 'text', 'value': 'Welcome'},
        'home.cta.background': {'type': 'color', 'value': '#FF3366'},
      });

      expect(values, hasLength(2));
      expect(values['home.title'], {'type': 'text', 'value': 'Welcome'});
      expect(values['home.cta.background'], {
        'type': 'color',
        'value': '#FF3366',
      });
    });

    test('drops entries with invalid ids, values, or types', () {
      final values = parseVariantValues({
        'valid': {'type': 'text', 'value': 'Valid'},
        123: {'type': 'text', 'value': 'Invalid id'},
        'invalid.value': 'not a map',
        'invalid.type': {'type': 123, 'value': 'Invalid type'},
        'missing.type': {'value': 'Missing type'},
      });

      expect(values, hasLength(1));
      expect(values['valid'], {'type': 'text', 'value': 'Valid'});
    });

    test('copies values into string-keyed maps', () {
      final source = {
        'home.title': {'type': 'text', 'value': 'Welcome'},
      };

      final values = parseVariantValues(source);
      source['home.title']?['value'] = 'Changed';

      expect(values['home.title']?['value'], 'Welcome');
    });
  });

  group('parseVariantValuesWithIssues', () {
    test('returns values and no issues for valid entries', () {
      final result = parseVariantValuesWithIssues({
        'home.title': {'type': 'text', 'value': 'Welcome'},
        'home.visible': {'type': 'bool', 'value': true},
      });

      expect(result.values, {
        'home.title': {'type': 'text', 'value': 'Welcome'},
        'home.visible': {'type': 'bool', 'value': true},
      });
      expect(result.issues, isEmpty);
    });

    test('reports an invalid root issue', () {
      final result = parseVariantValuesWithIssues('invalid');

      expect(result.values, isEmpty);
      expect(result.issues, hasLength(1));
      expect(result.issues.single.code, VariantParseIssueCode.invalidRoot);
      expect(result.issues.single.id, isNull);
    });

    test('reports invalid entry issues', () {
      final result = parseVariantValuesWithIssues({
        123: {'type': 'text', 'value': 'Invalid id'},
        'invalid.value': 'not a map',
        'missing.type': {'value': 'Missing type'},
        'invalid.type': {'type': 123, 'value': 'Invalid type'},
      });

      expect(result.values, isEmpty);
      expect(result.issues.map((issue) => issue.code), [
        VariantParseIssueCode.invalidId,
        VariantParseIssueCode.invalidValue,
        VariantParseIssueCode.missingType,
        VariantParseIssueCode.invalidType,
      ]);
      expect(result.issues.map((issue) => issue.id), [
        123,
        'invalid.value',
        'missing.type',
        'invalid.type',
      ]);
    });

    test('reports non-string field keys without throwing', () {
      final result = parseVariantValuesWithIssues({
        'invalid.field': {'type': 'text', 123: 'Invalid field key'},
      });

      expect(result.values, isEmpty);
      expect(result.issues, hasLength(1));
      expect(result.issues.single.code, VariantParseIssueCode.invalidFieldKey);
      expect(result.issues.single.id, 'invalid.field');
    });
  });
}
