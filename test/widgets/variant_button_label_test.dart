import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantButtonLabel', () {
    testWidgets('renders fallback without a variant scope', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VariantButtonLabel(
              id: 'home.cta.label',
              fallback: 'Continue',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('renders the variant label from the variant scope', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VariantScope(
            values: const {
              'home.cta.label': {'type': 'text', 'value': 'Start now'},
            },
            child: Scaffold(
              body: VariantButtonLabel(
                id: 'home.cta.label',
                fallback: 'Continue',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Start now'), findsOneWidget);
      expect(find.text('Continue'), findsNothing);
    });

    testWidgets('invokes onPressed when tapped', (tester) async {
      var taps = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VariantButtonLabel(
              id: 'home.cta.label',
              fallback: 'Continue',
              onPressed: () => taps++,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('keeps the button disabled when onPressed is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VariantButtonLabel(
              id: 'home.cta.label',
              fallback: 'Continue',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('uses fallback when the variant value has the wrong type', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VariantScope(
            values: const {
              'home.cta.label': {'type': 'image', 'value': 'Start now'},
            },
            child: Scaffold(
              body: VariantButtonLabel(
                id: 'home.cta.label',
                fallback: 'Continue',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Continue'), findsOneWidget);
    });
  });
}
