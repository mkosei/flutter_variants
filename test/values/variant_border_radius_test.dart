import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantBorderRadius', () {
    testWidgets('returns fallback without a variant scope', (tester) async {
      late BorderRadius radius;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            radius = VariantBorderRadius.of(
              context,
              id: 'home.card.radius',
              fallback: BorderRadius.circular(8),
            );
            return const SizedBox.shrink();
          },
        ),
      );

      expect(radius, BorderRadius.circular(8));
    });

    testWidgets('resolves a uniform num value to BorderRadius.circular', (
      tester,
    ) async {
      late BorderRadius radius;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.card.radius': {'type': 'borderRadius', 'value': 16},
          },
          child: Builder(
            builder: (context) {
              radius = VariantBorderRadius.of(
                context,
                id: 'home.card.radius',
                fallback: BorderRadius.circular(8),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(radius, BorderRadius.circular(16));
    });

    testWidgets('resolves per-corner values from a map', (tester) async {
      late BorderRadius radius;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.card.radius': {
              'type': 'borderRadius',
              'value': {
                'topLeft': 12,
                'topRight': 12,
                'bottomLeft': 0,
                'bottomRight': 4,
              },
            },
          },
          child: Builder(
            builder: (context) {
              radius = VariantBorderRadius.of(
                context,
                id: 'home.card.radius',
                fallback: BorderRadius.circular(8),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        radius,
        const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(4),
        ),
      );
    });

    testWidgets('treats missing or invalid corners as zero', (tester) async {
      late BorderRadius radius;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.card.radius': {
              'type': 'borderRadius',
              'value': {'topLeft': 12, 'topRight': '12'},
            },
          },
          child: Builder(
            builder: (context) {
              radius = VariantBorderRadius.of(
                context,
                id: 'home.card.radius',
                fallback: BorderRadius.circular(8),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        radius,
        const BorderRadius.only(topLeft: Radius.circular(12)),
      );
    });

    testWidgets('uses fallback for invalid variant border radius values', (
      tester,
    ) async {
      final values = <Map<String, Map<String, dynamic>>>[
        {},
        {
          'home.card.radius': {'type': 'spacing', 'value': 12},
        },
        {
          'home.card.radius': {'type': 'borderRadius', 'value': '12'},
        },
      ];

      for (final value in values) {
        late BorderRadius radius;

        await tester.pumpWidget(
          VariantScope(
            values: value,
            child: Builder(
              builder: (context) {
                radius = VariantBorderRadius.of(
                  context,
                  id: 'home.card.radius',
                  fallback: BorderRadius.circular(8),
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(radius, BorderRadius.circular(8));
      }
    });
  });
}
