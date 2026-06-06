import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantIcon', () {
    final approved = {
      'shopping_cart': Icons.shopping_cart,
      'star': Icons.star,
      'favorite': Icons.favorite,
    };

    testWidgets('renders fallback without a variant scope', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VariantIcon(
            id: 'home.cta.icon',
            fallback: Icons.shopping_cart,
            approvedIcons: approved,
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.shopping_cart);
    });

    testWidgets('renders an icon from the approved set', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VariantScope(
            values: const {
              'home.cta.icon': {'type': 'icon', 'value': 'star'},
            },
            child: VariantIcon(
              id: 'home.cta.icon',
              fallback: Icons.shopping_cart,
              approvedIcons: approved,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.star);
    });

    testWidgets('falls back when the identifier is not in the approved set', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VariantScope(
            values: const {
              'home.cta.icon': {'type': 'icon', 'value': 'delete'},
            },
            child: VariantIcon(
              id: 'home.cta.icon',
              fallback: Icons.shopping_cart,
              approvedIcons: approved,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.shopping_cart);
    });

    testWidgets('falls back when the variant value has the wrong type', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VariantScope(
            values: const {
              'home.cta.icon': {'type': 'text', 'value': 'star'},
            },
            child: VariantIcon(
              id: 'home.cta.icon',
              fallback: Icons.shopping_cart,
              approvedIcons: approved,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.shopping_cart);
    });

    testWidgets('forwards size, color, and semanticLabel', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VariantIcon(
            id: 'home.cta.icon',
            fallback: Icons.shopping_cart,
            approvedIcons: approved,
            size: 32,
            color: const Color(0xFF112233),
            semanticLabel: 'Cart',
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 32);
      expect(icon.color, const Color(0xFF112233));
      expect(icon.semanticLabel, 'Cart');
    });
  });
}
