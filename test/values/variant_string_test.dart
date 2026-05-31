import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantString', () {
    testWidgets('returns fallback without a variant scope', (tester) async {
      late String value;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            value = VariantString.of(
              context,
              id: 'home.title',
              fallback: 'Welcome',
            );
            return const SizedBox.shrink();
          },
        ),
      );

      expect(value, 'Welcome');
    });

    testWidgets('resolves a string value from the variant scope', (
      tester,
    ) async {
      late String value;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.title': {'type': 'string', 'value': 'New launch'},
          },
          child: Builder(
            builder: (context) {
              value = VariantString.of(
                context,
                id: 'home.title',
                fallback: 'Welcome',
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(value, 'New launch');
    });

    testWidgets('uses fallback for invalid variant string values', (
      tester,
    ) async {
      final values = <Map<String, Map<String, dynamic>>>[
        {},
        {
          'home.title': {'type': 'text', 'value': 'New launch'},
        },
        {
          'home.title': {'type': 'string', 'value': 42},
        },
      ];

      for (final value in values) {
        late String resolved;

        await tester.pumpWidget(
          VariantScope(
            values: value,
            child: Builder(
              builder: (context) {
                resolved = VariantString.of(
                  context,
                  id: 'home.title',
                  fallback: 'Welcome',
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved, 'Welcome');
      }
    });
  });
}
