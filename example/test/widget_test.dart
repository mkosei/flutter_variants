import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('renders fallback values before variants load', (tester) async {
    await tester.pumpWidget(const DemoApp());

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Browse all'), findsOneWidget);
  });

  testWidgets('renders the default preset after load', (tester) async {
    await tester.pumpWidget(const DemoApp());
    await tester.pumpAndSettle();

    expect(find.text("Today's picks"), findsOneWidget);
    expect(find.text('Recommended'), findsOneWidget);
    expect(find.text('Classic Tee'), findsOneWidget);
  });

  testWidgets('switches to the sale preset from the AppBar dropdown', (
    tester,
  ) async {
    await tester.pumpWidget(const DemoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<VariantPreset>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sale').last);
    await tester.pumpAndSettle();

    expect(find.text('Spring Sale — up to 40% off'), findsOneWidget);
    expect(find.text('On sale now'), findsOneWidget);
    expect(find.text('Shop the sale'), findsOneWidget);
  });

  testWidgets('switches to the holiday preset from the AppBar dropdown', (
    tester,
  ) async {
    await tester.pumpWidget(const DemoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<VariantPreset>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Holiday').last);
    await tester.pumpAndSettle();

    expect(find.text('Happy Holidays'), findsOneWidget);
    expect(find.text('Holiday gift picks'), findsOneWidget);
    expect(find.text('Shop holiday gifts'), findsOneWidget);
  });
}
