import 'package:page_ui/core/database/cache/secure_storage.dart';
import 'package:page_ui/core/helpers/setup_service_locator_getit.dart';
import 'package:page_ui/main_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  SecureStorage.init();
  setUpServiceLocator();
  runApp(const PageDotUi());
}
