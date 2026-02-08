import 'package:flutter/material.dart';
import 'package:pageui/core/database/cache/cache_helper.dart';
import 'package:pageui/core/database/cache/secure_storage.dart';
import 'package:pageui/main_app.dart';

void main() {
  CacheHelper cacheHelper = CacheHelper();
  cacheHelper.init();
  SecureStorage.init();
  runApp(const PageDotUi());
}
