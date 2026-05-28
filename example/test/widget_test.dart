import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('renders remote text slots inside native UI', (tester) async {
    await tester.pumpWidget(const DemoApp());

    expect(find.text('Flutter Variants Demo'), findsOneWidget);
    expect(find.text('Variant A'), findsOneWidget);
    expect(find.text('Rendered from a remote text slot'), findsOneWidget);
    expect(find.text('Start now'), findsOneWidget);
  });
}
