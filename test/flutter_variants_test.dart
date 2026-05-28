import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

final fallbackImage = MemoryImage(
  Uint8List.fromList(<int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ]),
);

void main() {
  group('VariantText', () {
    testWidgets('renders its fallback without a variant scope', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: VariantText(id: 'home.title', fallback: 'Welcome'),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('renders a variant text value from the variant scope', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: VariantScope(
            values: {
              'home.title': {'type': 'text', 'value': 'Try the new onboarding'},
            },
            child: VariantText(id: 'home.title', fallback: 'Welcome'),
          ),
        ),
      );

      expect(find.text('Try the new onboarding'), findsOneWidget);
      expect(find.text('Welcome'), findsNothing);
    });

    testWidgets('uses fallback when the variant value is missing', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: VariantScope(
            values: {},
            child: VariantText(id: 'home.title', fallback: 'Welcome'),
          ),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('uses fallback when the variant value has the wrong type', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: VariantScope(
            values: {
              'home.title': {
                'type': 'image',
                'value': 'https://example.com/image.png',
              },
            },
            child: VariantText(id: 'home.title', fallback: 'Welcome'),
          ),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('uses fallback when the variant text value is not a string', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: VariantScope(
            values: {
              'home.title': {'type': 'text', 'value': 123},
            },
            child: VariantText(id: 'home.title', fallback: 'Welcome'),
          ),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
    });
  });

  group('VariantImage', () {
    testWidgets('renders its fallback without a variant scope', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: VariantImage(id: 'home.hero.image', fallback: fallbackImage),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, fallbackImage);
    });

    test('resolves a network image from a valid variant value', () {
      final image = VariantImage(
        id: 'home.hero.image',
        fallback: fallbackImage,
      );

      final provider = image.resolveImage({
        'type': 'image',
        'value': 'https://example.com/hero.png',
      });

      expect(provider, isA<NetworkImage>());
      expect((provider as NetworkImage).url, 'https://example.com/hero.png');
    });

    testWidgets('uses fallback when the variant image is missing', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: VariantScope(
            values: const {},
            child: VariantImage(id: 'home.hero.image', fallback: fallbackImage),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, fallbackImage);
    });

    testWidgets('uses fallback when the variant value has the wrong type', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: VariantScope(
            values: const {
              'home.hero.image': {'type': 'text', 'value': 'Not an image'},
            },
            child: VariantImage(id: 'home.hero.image', fallback: fallbackImage),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, fallbackImage);
    });

    testWidgets('uses fallback when the variant image value is not a string', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: VariantScope(
            values: const {
              'home.hero.image': {'type': 'image', 'value': 123},
            },
            child: VariantImage(id: 'home.hero.image', fallback: fallbackImage),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, fallbackImage);
    });
  });
}
