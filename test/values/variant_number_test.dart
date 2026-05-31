import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantNumber', () {
    testWidgets('returns fallback without a variant scope', (tester) async {
      late num value;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            value = VariantNumber.of(
              context,
              id: 'home.list.max_items',
              fallback: 10,
            );
            return const SizedBox.shrink();
          },
        ),
      );

      expect(value, 10);
    });

    testWidgets('resolves an integer value from the variant scope', (
      tester,
    ) async {
      late num value;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.list.max_items': {'type': 'number', 'value': 25},
          },
          child: Builder(
            builder: (context) {
              value = VariantNumber.of(
                context,
                id: 'home.list.max_items',
                fallback: 10,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(value, 25);
    });

    testWidgets('resolves a double value from the variant scope', (
      tester,
    ) async {
      late num value;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.opacity': {'type': 'number', 'value': 0.75},
          },
          child: Builder(
            builder: (context) {
              value = VariantNumber.of(
                context,
                id: 'home.opacity',
                fallback: 1.0,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(value, 0.75);
    });

    testWidgets('clamps numeric values to the allowed range', (tester) async {
      late num smallValue;
      late num largeValue;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.too_small': {'type': 'number', 'value': -5},
            'home.too_large': {'type': 'number', 'value': 500},
          },
          child: Builder(
            builder: (context) {
              smallValue = VariantNumber.of(
                context,
                id: 'home.too_small',
                fallback: 10,
                min: 0,
                max: 100,
              );
              largeValue = VariantNumber.of(
                context,
                id: 'home.too_large',
                fallback: 10,
                min: 0,
                max: 100,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(smallValue, 0);
      expect(largeValue, 100);
    });

    testWidgets('uses fallback for invalid variant number values', (
      tester,
    ) async {
      final values = <Map<String, Map<String, dynamic>>>[
        {},
        {
          'home.opacity': {'type': 'spacing', 'value': 0.5},
        },
        {
          'home.opacity': {'type': 'number', 'value': '0.5'},
        },
      ];

      for (final value in values) {
        late num resolved;

        await tester.pumpWidget(
          VariantScope(
            values: value,
            child: Builder(
              builder: (context) {
                resolved = VariantNumber.of(
                  context,
                  id: 'home.opacity',
                  fallback: 1.0,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolved, 1.0);
      }
    });
  });
}
