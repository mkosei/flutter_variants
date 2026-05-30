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
}
