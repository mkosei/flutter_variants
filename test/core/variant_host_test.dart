import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';

void main() {
  group('VariantHost', () {
    testWidgets('renders initial values before loaded values arrive', (
      tester,
    ) async {
      final completer = Completer<VariantValues>();

      await tester.pumpWidget(
        MaterialApp(
          home: VariantHost(
            url: Uri.parse('https://example.com/variants.json'),
            initialValues: const {
              'home.title': {'type': 'text', 'value': 'Initial'},
            },
            loader: (_) => completer.future,
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        ),
      );

      expect(find.text('Initial'), findsOneWidget);
      expect(find.text('Fallback'), findsNothing);
    });

    testWidgets('renders loaded variant values', (tester) async {
      final completer = Completer<VariantValues>();

      await tester.pumpWidget(
        MaterialApp(
          home: VariantHost(
            url: Uri.parse('https://example.com/variants.json'),
            loader: (_) => completer.future,
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        ),
      );

      expect(find.text('Fallback'), findsOneWidget);

      completer.complete({
        'home.title': {'type': 'text', 'value': 'Loaded'},
      });
      await tester.pump();

      expect(find.text('Loaded'), findsOneWidget);
      expect(find.text('Fallback'), findsNothing);
    });

    testWidgets('keeps fallback values when loading fails', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VariantHost(
            url: Uri.parse('https://example.com/variants.json'),
            loader: (_) => Future<VariantValues>.error(Exception('Failed')),
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Fallback'), findsOneWidget);
    });

    testWidgets('reloads values when the URL changes', (tester) async {
      final first = Completer<VariantValues>();
      final second = Completer<VariantValues>();
      var url = Uri.parse('https://example.com/first.json');

      Future<VariantValues> loader(Uri requestedUrl) {
        if (requestedUrl.path.endsWith('first.json')) {
          return first.future;
        }

        return second.future;
      }

      Widget build() {
        return MaterialApp(
          home: VariantHost(
            url: url,
            loader: loader,
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        );
      }

      await tester.pumpWidget(build());

      first.complete({
        'home.title': {'type': 'text', 'value': 'First'},
      });
      await tester.pump();

      expect(find.text('First'), findsOneWidget);

      url = Uri.parse('https://example.com/second.json');
      await tester.pumpWidget(build());

      second.complete({
        'home.title': {'type': 'text', 'value': 'Second'},
      });
      await tester.pumpAndSettle();

      expect(find.text('Second'), findsOneWidget);
      expect(find.text('First'), findsNothing);
    });
  });
}
