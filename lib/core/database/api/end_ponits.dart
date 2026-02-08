import 'package:dio/dio.dart';

class EndPoint {
  EndPoint();
  static const String baseUrl = '';
}

Options headers({required String token}) => Options(
  headers: {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json",
  },
);
