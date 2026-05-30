import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('renders fallback values before variants load', (tester) async {
    await tester.pumpWidget(const DemoApp());

    expect(find.text('Default title'), findsOneWidget);
    expect(find.text('Default body copy'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('renders values from the bundled variants.json', (tester) async {
    await tester.pumpWidget(const DemoApp());
    await tester.pumpAndSettle();

    expect(find.text('Flutter Variants Demo'), findsOneWidget);
    expect(find.text('春の新作セール開催中'), findsOneWidget);
    expect(find.text('対象商品が最大40%オフ。3/31まで。'), findsOneWidget);
    expect(find.text('新規登録で500円OFFクーポンプレゼント'), findsOneWidget);
    expect(find.text('セール会場を見る'), findsOneWidget);
  });
}
