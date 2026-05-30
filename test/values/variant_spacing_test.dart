import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantSpacing', () {
    testWidgets('returns fallback without a variant scope', (tester) async {
      late double spacing;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            spacing = VariantSpacing.of(
              context,
              id: 'home.section.spacing',
              fallback: 24,
            );
            return const SizedBox.shrink();
          },
        ),
      );

      expect(spacing, 24);
    });

    testWidgets('resolves an integer spacing value from the variant scope', (
      tester,
    ) async {
      late double spacing;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.section.spacing': {'type': 'spacing', 'value': 32},
          },
          child: Builder(
            builder: (context) {
              spacing = VariantSpacing.of(
                context,
                id: 'home.section.spacing',
                fallback: 24,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(spacing, 32);
    });

    testWidgets('resolves a double spacing value from the variant scope', (
      tester,
    ) async {
      late double spacing;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.section.spacing': {'type': 'spacing', 'value': 20.5},
          },
          child: Builder(
            builder: (context) {
              spacing = VariantSpacing.of(
                context,
                id: 'home.section.spacing',
                fallback: 24,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(spacing, 20.5);
    });

    testWidgets('clamps spacing values to the allowed range', (tester) async {
      late double smallSpacing;
      late double largeSpacing;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.section.small_spacing': {'type': 'spacing', 'value': -10},
            'home.section.large_spacing': {'type': 'spacing', 'value': 200},
          },
          child: Builder(
            builder: (context) {
              smallSpacing = VariantSpacing.of(
                context,
                id: 'home.section.small_spacing',
                fallback: 24,
                min: 0,
                max: 64,
              );
              largeSpacing = VariantSpacing.of(
                context,
                id: 'home.section.large_spacing',
                fallback: 24,
                min: 0,
                max: 64,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(smallSpacing, 0);
      expect(largeSpacing, 64);
    });

    testWidgets('uses fallback for invalid variant spacing values', (
      tester,
    ) async {
      final values = <Map<String, Map<String, dynamic>>>[
        {},
        {
          'home.section.spacing': {'type': 'text', 'value': 32},
        },
        {
          'home.section.spacing': {'type': 'spacing', 'value': '32'},
        },
      ];

      for (final value in values) {
        late double spacing;

        await tester.pumpWidget(
          VariantScope(
            values: value,
            child: Builder(
              builder: (context) {
                spacing = VariantSpacing.of(
                  context,
                  id: 'home.section.spacing',
                  fallback: 24,
                  min: 0,
                  max: 64,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(spacing, 24);
      }
    });
  });
}
