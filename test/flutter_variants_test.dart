import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('parseRemoteNode', () {
    test('parses a text schema into a RemoteNode', () {
      final node = parseRemoteNode({
        'type': 'text',
        'value': 'Hello',
      });

      expect(node.type, 'text');
      expect(node.props['value'], 'Hello');
      expect(node.children, isEmpty);
    });

    test('parses child schemas recursively', () {
      final node = parseRemoteNode({
        'type': 'column',
        'children': [
          {
            'type': 'text',
            'value': 'Hello',
          },
          {
            'type': 'text',
            'value': 'World',
          },
        ],
      });

      expect(node.type, 'column');
      expect(node.children, hasLength(2));
      expect(node.children[0].type, 'text');
      expect(node.children[0].props['value'], 'Hello');
      expect(node.children[1].type, 'text');
      expect(node.children[1].props['value'], 'World');
    });
  });

  group('RemoteRenderer', () {
    testWidgets('renders a text schema', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: RemoteRenderer(
            schema: {
              'type': 'text',
              'value': 'Hello',
            },
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('renders a column schema with text children', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: RemoteRenderer(
            schema: {
              'type': 'column',
              'children': [
                {
                  'type': 'text',
                  'value': 'Hello',
                },
                {
                  'type': 'text',
                  'value': 'World',
                },
              ],
            },
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('World'), findsOneWidget);
    });

    testWidgets('falls back safely for an unknown widget type', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: RemoteRenderer(
            schema: {
              'type': 'unknown_widget',
            },
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
