import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('renders the remote schema demo', (tester) async {
    await tester.pumpWidget(const DemoApp());

    expect(find.text('Flutter Variants Demo'), findsOneWidget);
    expect(find.text('Variant A'), findsOneWidget);
    expect(find.text('Rendered from remote schema'), findsOneWidget);
  });
}
