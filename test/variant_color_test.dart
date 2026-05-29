import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantColor', () {
    testWidgets('returns fallback without a variant scope', (tester) async {
      late Color color;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            color = VariantColor.of(
              context,
              id: 'home.cta.background',
              fallback: const Color(0xFF0000FF),
            );
            return const SizedBox.shrink();
          },
        ),
      );

      expect(color, const Color(0xFF0000FF));
    });

    testWidgets('resolves a #RRGGBB color from the variant scope', (
      tester,
    ) async {
      late Color color;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.cta.background': {'type': 'color', 'value': '#FF3366'},
          },
          child: Builder(
            builder: (context) {
              color = VariantColor.of(
                context,
                id: 'home.cta.background',
                fallback: const Color(0xFF0000FF),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(color, const Color(0xFFFF3366));
    });

    testWidgets('resolves a #AARRGGBB color from the variant scope', (
      tester,
    ) async {
      late Color color;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.cta.background': {'type': 'color', 'value': '#80FF3366'},
          },
          child: Builder(
            builder: (context) {
              color = VariantColor.of(
                context,
                id: 'home.cta.background',
                fallback: const Color(0xFF0000FF),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(color, const Color(0x80FF3366));
    });

    testWidgets('uses fallback for invalid variant color values', (
      tester,
    ) async {
      const fallback = Color(0xFF0000FF);
      final values = <Map<String, Map<String, dynamic>>>[
        {},
        {
          'home.cta.background': {'type': 'text', 'value': '#FF3366'},
        },
        {
          'home.cta.background': {'type': 'color', 'value': 123},
        },
        {
          'home.cta.background': {'type': 'color', 'value': 'FF3366'},
        },
        {
          'home.cta.background': {'type': 'color', 'value': '#NOPE'},
        },
      ];

      for (final value in values) {
        late Color color;

        await tester.pumpWidget(
          VariantScope(
            values: value,
            child: Builder(
              builder: (context) {
                color = VariantColor.of(
                  context,
                  id: 'home.cta.background',
                  fallback: fallback,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(color, fallback);
      }
    });
  });
}
