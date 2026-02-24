import 'package:flutter/material.dart';
import 'package:pageui/core/database/api/graph_ql_config.dart';
import 'package:pageui/core/database/cache/secure_storage.dart';
import 'package:pageui/core/helpers/setup_service_locator_getit.dart';
import 'package:pageui/main_app.dart';

void main() {
  // CacheHelper cacheHelper = CacheHelper();
  // cacheHelper.init();
  initializeAuth();
  SecureStorage.init();
  setUpServiceLocator();
  runApp(const PageDotUi());
}
