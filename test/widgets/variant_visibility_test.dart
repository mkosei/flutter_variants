import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantVisibility', () {
    testWidgets('uses fallback without a variant scope', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: VariantVisibility(
            id: 'home.banner.visible',
            fallback: true,
            replacement: Text('Hidden'),
            child: Text('Banner'),
          ),
        ),
      );

      expect(find.text('Banner'), findsOneWidget);
      expect(find.text('Hidden'), findsNothing);
    });

    testWidgets('shows child when the variant value is true', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: VariantScope(
            values: {
              'home.banner.visible': {'type': 'bool', 'value': true},
            },
            child: VariantVisibility(
              id: 'home.banner.visible',
              fallback: false,
              replacement: Text('Hidden'),
              child: Text('Banner'),
            ),
          ),
        ),
      );

      expect(find.text('Banner'), findsOneWidget);
      expect(find.text('Hidden'), findsNothing);
    });

    testWidgets('shows replacement when the variant value is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: VariantScope(
            values: {
              'home.banner.visible': {'type': 'bool', 'value': false},
            },
            child: VariantVisibility(
              id: 'home.banner.visible',
              fallback: true,
              replacement: Text('Hidden'),
              child: Text('Banner'),
            ),
          ),
        ),
      );

      expect(find.text('Banner'), findsNothing);
      expect(find.text('Hidden'), findsOneWidget);
    });

    testWidgets('uses fallback for invalid variant values', (tester) async {
      final values = <Map<String, Map<String, dynamic>>>[
        {},
        {
          'home.banner.visible': {'type': 'text', 'value': true},
        },
        {
          'home.banner.visible': {'type': 'bool', 'value': 'true'},
        },
      ];

      for (final value in values) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: VariantScope(
              values: value,
              child: const VariantVisibility(
                id: 'home.banner.visible',
                fallback: false,
                replacement: Text('Hidden'),
                child: Text('Banner'),
              ),
            ),
          ),
        );

        expect(find.text('Banner'), findsNothing);
        expect(find.text('Hidden'), findsOneWidget);
      }
    });

    testWidgets('defaults replacement to an empty box', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: VariantVisibility(
            id: 'home.banner.visible',
            fallback: false,
            child: Text('Banner'),
          ),
        ),
      );

      expect(find.text('Banner'), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
