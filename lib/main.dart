import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:page_ui/core/database/cache/secure_storage.dart';
import 'package:page_ui/core/helpers/setup_service_locator_getit.dart';
import 'package:page_ui/main_app.dart';

void main() {
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  SecureStorage.init();
  setUpServiceLocator();
  runApp(const PageDotUi());
}
