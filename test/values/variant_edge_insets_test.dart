import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantEdgeInsets', () {
    testWidgets('returns fallback without a variant scope', (tester) async {
      late EdgeInsets insets;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            insets = VariantEdgeInsets.of(
              context,
              id: 'home.section.padding',
              fallback: const EdgeInsets.all(16),
            );
            return const SizedBox.shrink();
          },
        ),
      );

      expect(insets, const EdgeInsets.all(16));
    });

    testWidgets('resolves a uniform num value to EdgeInsets.all', (
      tester,
    ) async {
      late EdgeInsets insets;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.section.padding': {'type': 'edgeInsets', 'value': 12},
          },
          child: Builder(
            builder: (context) {
              insets = VariantEdgeInsets.of(
                context,
                id: 'home.section.padding',
                fallback: const EdgeInsets.all(16),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(insets, const EdgeInsets.all(12));
    });

    testWidgets('resolves per-side values from a map', (tester) async {
      late EdgeInsets insets;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.section.padding': {
              'type': 'edgeInsets',
              'value': {'left': 8, 'top': 4, 'right': 8, 'bottom': 12},
            },
          },
          child: Builder(
            builder: (context) {
              insets = VariantEdgeInsets.of(
                context,
                id: 'home.section.padding',
                fallback: const EdgeInsets.all(16),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(insets, const EdgeInsets.fromLTRB(8, 4, 8, 12));
    });

    testWidgets('treats missing or invalid sides as zero', (tester) async {
      late EdgeInsets insets;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.section.padding': {
              'type': 'edgeInsets',
              'value': {'left': 8, 'top': '4'},
            },
          },
          child: Builder(
            builder: (context) {
              insets = VariantEdgeInsets.of(
                context,
                id: 'home.section.padding',
                fallback: const EdgeInsets.all(16),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(insets, const EdgeInsets.only(left: 8));
    });

    testWidgets('uses fallback for invalid variant edge insets values', (
      tester,
    ) async {
      final values = <Map<String, Map<String, dynamic>>>[
        {},
        {
          'home.section.padding': {'type': 'spacing', 'value': 12},
        },
        {
          'home.section.padding': {'type': 'edgeInsets', 'value': '12'},
        },
      ];

      for (final value in values) {
        late EdgeInsets insets;

        await tester.pumpWidget(
          VariantScope(
            values: value,
            child: Builder(
              builder: (context) {
                insets = VariantEdgeInsets.of(
                  context,
                  id: 'home.section.padding',
                  fallback: const EdgeInsets.all(16),
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(insets, const EdgeInsets.all(16));
      }
    });
  });
}
