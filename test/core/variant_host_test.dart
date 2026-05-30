import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_variants/flutter_variants.dart';
import 'package:flutter_variants/src/loader/variant_values_memory_cache.dart';

void main() {
  group('VariantHost', () {
    setUp(VariantValuesMemoryCache.clear);

    testWidgets('renders initial values before loaded values arrive', (
      tester,
    ) async {
      final completer = Completer<VariantLoadResult>();

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
      final completer = Completer<VariantLoadResult>();

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

      completer.complete(
        const VariantLoadResult(
          values: {
            'home.title': {'type': 'text', 'value': 'Loaded'},
          },
        ),
      );
      await tester.pump();

      expect(find.text('Loaded'), findsOneWidget);
      expect(find.text('Fallback'), findsNothing);
    });

    testWidgets('calls onLoaded after values are loaded', (tester) async {
      final completer = Completer<VariantLoadResult>();
      VariantValues? loadedValues;

      await tester.pumpWidget(
        MaterialApp(
          home: VariantHost(
            url: Uri.parse('https://example.com/variants.json'),
            loader: (_) => completer.future,
            onLoaded: (values) {
              loadedValues = values;
            },
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        ),
      );

      completer.complete(
        const VariantLoadResult(
          values: {
            'home.title': {'type': 'text', 'value': 'Loaded'},
          },
        ),
      );
      await tester.pump();

      expect(loadedValues, {
        'home.title': {'type': 'text', 'value': 'Loaded'},
      });
    });

    testWidgets('keeps fallback values when loading fails', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: VariantHost(
            url: Uri.parse('https://example.com/variants.json'),
            loader: (_) => Future<VariantLoadResult>.error(Exception('Failed')),
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Fallback'), findsOneWidget);
    });

    testWidgets('calls onLoadError when loading fails', (tester) async {
      Object? loadError;
      StackTrace? loadStackTrace;

      await tester.pumpWidget(
        MaterialApp(
          home: VariantHost(
            url: Uri.parse('https://example.com/variants.json'),
            loader: (_) => Future<VariantLoadResult>.error(Exception('Failed')),
            onLoadError: (error, stackTrace) {
              loadError = error;
              loadStackTrace = stackTrace;
            },
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        ),
      );

      await tester.pump();

      expect(loadError, isA<Exception>());
      expect(loadStackTrace, isNotNull);
      expect(find.text('Fallback'), findsOneWidget);
    });

    testWidgets('keeps fallback values when loading times out', (tester) async {
      Object? loadError;

      await tester.pumpWidget(
        MaterialApp(
          home: VariantHost(
            url: Uri.parse('https://example.com/variants.json'),
            timeout: const Duration(milliseconds: 10),
            loader: (_) => Completer<VariantLoadResult>().future,
            onLoadError: (error, _) {
              loadError = error;
            },
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 11));
      await tester.pump();

      expect(loadError, isA<TimeoutException>());
      expect(find.text('Fallback'), findsOneWidget);
    });

    testWidgets('reloads values when the URL changes', (tester) async {
      final first = Completer<VariantLoadResult>();
      final second = Completer<VariantLoadResult>();
      var url = Uri.parse('https://example.com/first.json');

      Future<VariantLoadResult> loader(Uri requestedUrl) {
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

      first.complete(
        const VariantLoadResult(
          values: {
            'home.title': {'type': 'text', 'value': 'First'},
          },
        ),
      );
      await tester.pump();

      expect(find.text('First'), findsOneWidget);

      url = Uri.parse('https://example.com/second.json');
      await tester.pumpWidget(build());

      second.complete(
        const VariantLoadResult(
          values: {
            'home.title': {'type': 'text', 'value': 'Second'},
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Second'), findsOneWidget);
      expect(find.text('First'), findsNothing);
    });

    testWidgets('renders cached values before loaded values arrive', (
      tester,
    ) async {
      final url = Uri.parse('https://example.com/variants.json');
      final completer = Completer<VariantLoadResult>();

      VariantValuesMemoryCache.set(url, {
        'home.title': {'type': 'text', 'value': 'Cached'},
      });

      await tester.pumpWidget(
        MaterialApp(
          home: VariantHost(
            url: url,
            loader: (_) => completer.future,
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        ),
      );

      expect(find.text('Cached'), findsOneWidget);
      expect(find.text('Fallback'), findsNothing);
    });

    testWidgets('updates cached values after loading succeeds', (tester) async {
      final url = Uri.parse('https://example.com/variants.json');
      final completer = Completer<VariantLoadResult>();

      VariantValuesMemoryCache.set(url, {
        'home.title': {'type': 'text', 'value': 'Cached'},
      });

      await tester.pumpWidget(
        MaterialApp(
          home: VariantHost(
            url: url,
            loader: (_) => completer.future,
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        ),
      );

      completer.complete(
        const VariantLoadResult(
          values: {
            'home.title': {'type': 'text', 'value': 'Loaded'},
          },
        ),
      );
      await tester.pump();

      expect(find.text('Loaded'), findsOneWidget);
      expect(VariantValuesMemoryCache.get(url), {
        'home.title': {'type': 'text', 'value': 'Loaded'},
      });
    });

    testWidgets('ignores cached values when cache is disabled', (tester) async {
      final url = Uri.parse('https://example.com/variants.json');
      final completer = Completer<VariantLoadResult>();

      VariantValuesMemoryCache.set(url, {
        'home.title': {'type': 'text', 'value': 'Cached'},
      });

      await tester.pumpWidget(
        MaterialApp(
          home: VariantHost(
            url: url,
            cache: false,
            loader: (_) => completer.future,
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        ),
      );

      expect(find.text('Fallback'), findsOneWidget);
      expect(find.text('Cached'), findsNothing);
    });

    testWidgets('keeps cached values when loading fails', (tester) async {
      final url = Uri.parse('https://example.com/variants.json');

      VariantValuesMemoryCache.set(url, {
        'home.title': {'type': 'text', 'value': 'Cached'},
      });

      await tester.pumpWidget(
        MaterialApp(
          home: VariantHost(
            url: url,
            loader: (_) => Future<VariantLoadResult>.error(Exception('Failed')),
            child: const VariantText(id: 'home.title', fallback: 'Fallback'),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Cached'), findsOneWidget);
      expect(find.text('Fallback'), findsNothing);
    });
  });
}
