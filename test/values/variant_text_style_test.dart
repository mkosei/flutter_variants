import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantTextStyle', () {
    const fallback = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Color(0xFF000000),
      fontFamily: 'Default',
      letterSpacing: 0,
      height: 1.2,
      fontStyle: FontStyle.normal,
    );

    testWidgets('returns fallback without a variant scope', (tester) async {
      late TextStyle style;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            style = VariantTextStyle.of(
              context,
              id: 'home.title.style',
              fallback: fallback,
            );
            return const SizedBox.shrink();
          },
        ),
      );

      expect(style, fallback);
    });

    testWidgets('returns fallback for wrong type', (tester) async {
      late TextStyle style;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.title.style': {'type': 'text', 'value': 'wrong'},
          },
          child: Builder(
            builder: (context) {
              style = VariantTextStyle.of(
                context,
                id: 'home.title.style',
                fallback: fallback,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(style, fallback);
    });

    testWidgets('merges only the fields present in the variant value', (
      tester,
    ) async {
      late TextStyle style;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.title.style': {
              'type': 'textStyle',
              'value': {'fontSize': 24},
            },
          },
          child: Builder(
            builder: (context) {
              style = VariantTextStyle.of(
                context,
                id: 'home.title.style',
                fallback: fallback,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(style.fontSize, 24);
      expect(style.fontWeight, fallback.fontWeight);
      expect(style.color, fallback.color);
      expect(style.fontFamily, fallback.fontFamily);
      expect(style.letterSpacing, fallback.letterSpacing);
      expect(style.height, fallback.height);
      expect(style.fontStyle, fallback.fontStyle);
    });

    testWidgets('merges all supported fields', (tester) async {
      late TextStyle style;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.title.style': {
              'type': 'textStyle',
              'value': {
                'fontSize': 22,
                'fontWeight': 'bold',
                'color': '#FF3366',
                'fontFamily': 'Inter',
                'letterSpacing': 0.5,
                'height': 1.4,
                'fontStyle': 'italic',
              },
            },
          },
          child: Builder(
            builder: (context) {
              style = VariantTextStyle.of(
                context,
                id: 'home.title.style',
                fallback: fallback,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(style.fontSize, 22);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.color, const Color(0xFFFF3366));
      expect(style.fontFamily, 'Inter');
      expect(style.letterSpacing, 0.5);
      expect(style.height, 1.4);
      expect(style.fontStyle, FontStyle.italic);
    });

    testWidgets('accepts fontWeight as a numeric value', (tester) async {
      late TextStyle style;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.title.style': {
              'type': 'textStyle',
              'value': {'fontWeight': 500},
            },
          },
          child: Builder(
            builder: (context) {
              style = VariantTextStyle.of(
                context,
                id: 'home.title.style',
                fallback: fallback,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(style.fontWeight, FontWeight.w500);
    });

    testWidgets('keeps fallback for invalid fontWeight', (tester) async {
      late TextStyle style;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.title.style': {
              'type': 'textStyle',
              'value': {'fontWeight': 'ultra-mega'},
            },
          },
          child: Builder(
            builder: (context) {
              style = VariantTextStyle.of(
                context,
                id: 'home.title.style',
                fallback: fallback,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(style.fontWeight, fallback.fontWeight);
    });

    testWidgets('keeps fallback for invalid color', (tester) async {
      late TextStyle style;

      await tester.pumpWidget(
        VariantScope(
          values: const {
            'home.title.style': {
              'type': 'textStyle',
              'value': {'color': 'red'},
            },
          },
          child: Builder(
            builder: (context) {
              style = VariantTextStyle.of(
                context,
                id: 'home.title.style',
                fallback: fallback,
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(style.color, fallback.color);
    });
  });
}
