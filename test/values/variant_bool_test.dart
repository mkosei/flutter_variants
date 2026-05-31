import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantBool', () {
    testWidgets('returns fallback without a variant scope', (tester) async {
      late bool value;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            value = VariantBool.of(
              context,
              id: 'home.experiment',
              fallback: false,
            );
            return const SizedBox.shrink();
          },
        ),
      );

      expect(value, false);
    });

    testWidgets('resolves a bool value from the variant scope', (
      tester,
    ) async {
      late bool value;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.experiment': {'type': 'bool', 'value': true},
          },
          child: Builder(
            builder: (context) {
              value = VariantBool.of(
                context,
                id: 'home.experiment',
                fallback: false,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(value, true);
    });

    testWidgets('uses fallback for invalid variant bool values', (
      tester,
    ) async {
      final values = <Map<String, Map<String, dynamic>>>[
        {},
        {
          'home.experiment': {'type': 'string', 'value': 'true'},
        },
        {
          'home.experiment': {'type': 'bool', 'value': 'true'},
        },
      ];

      for (final value in values) {
        late bool resolved;

        await tester.pumpWidget(
          VariantScope(
            values: value,
            child: Builder(
              builder: (context) {
                resolved = VariantBool.of(
                  context,
                  id: 'home.experiment',
                  fallback: false,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved, false);
      }
    });
  });
}
