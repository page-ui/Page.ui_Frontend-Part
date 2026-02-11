import 'package:flutter_test/flutter_test.dart';
import 'package:pageui/main_app.dart';

void main() {
  testWidgets('PageDotUi renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const PageDotUi());
    expect(find.byType(PageDotUi), findsOneWidget);
  });
}
