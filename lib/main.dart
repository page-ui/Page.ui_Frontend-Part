import 'package:flutter/material.dart';
import 'package:pageui/core/database/cache/secure_storage.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/main_app.dart';

void main() {
  SecureStorage.init();
  setUpServiceLocator();
  runApp(const PageDotUi());
}
