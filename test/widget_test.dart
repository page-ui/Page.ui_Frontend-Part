import 'package:flutter_test/flutter_test.dart';
import 'package:pageui/core/database/cache/cache_helper.dart';
import 'package:pageui/core/database/cache/secure_storage.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/main_app.dart';

void main() {
  testWidgets('PageDotUi renders without crashing', (
    WidgetTester tester,
  ) async {
    // Initialize all dependencies before running the app
    // CacheHelper cacheHelper = CacheHelper();
    // cacheHelper.init();
    await SecureStorage.init();
    setUpServiceLocator();

    await tester.pumpWidget(const PageDotUi());
    expect(find.byType(PageDotUi), findsOneWidget);
  });
}
