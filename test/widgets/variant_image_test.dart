import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

import '../assets/test_image.dart';

void main() {
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
