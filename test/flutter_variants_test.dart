import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('RemoteText', () {
    testWidgets('renders its fallback without a variant scope', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: RemoteText(id: 'home.title', fallback: 'Welcome'),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('renders a remote text value from the variant scope', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: RemoteVariantScope(
            values: {
              'home.title': {'type': 'text', 'value': 'Try the new onboarding'},
            },
            child: RemoteText(id: 'home.title', fallback: 'Welcome'),
          ),
        ),
      );

      expect(find.text('Try the new onboarding'), findsOneWidget);
      expect(find.text('Welcome'), findsNothing);
    });

    testWidgets('uses fallback when the remote value is missing', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: RemoteVariantScope(
            values: {},
            child: RemoteText(id: 'home.title', fallback: 'Welcome'),
          ),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('uses fallback when the remote value has the wrong type', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: RemoteVariantScope(
            values: {
              'home.title': {
                'type': 'image',
                'value': 'https://example.com/image.png',
              },
            },
            child: RemoteText(id: 'home.title', fallback: 'Welcome'),
          ),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('uses fallback when the remote text value is not a string', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: RemoteVariantScope(
            values: {
              'home.title': {'type': 'text', 'value': 123},
            },
            child: RemoteText(id: 'home.title', fallback: 'Welcome'),
          ),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}
