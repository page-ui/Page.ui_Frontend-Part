import 'package:Page.ui/core/database/cache/secure_storage.dart';
import 'package:Page.ui/core/helpers/setup_service_locator_getit.dart';
import 'package:Page.ui/main_app.dart';
import 'package:flutter/material.dart';

void main() {
  SecureStorage.init();
  setUpServiceLocator();
  runApp(const PageDotUi());
}
