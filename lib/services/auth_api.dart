// lib/services/auth_api.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_config.dart';

class AuthApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: kApiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    debugPrint('[AUTH_API] POST $kApiBaseUrl/login');
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });
    debugPrint('[AUTH_API] status: ${response.statusCode}');
    debugPrint('[AUTH_API] raw data: ${response.data}');
    debugPrint('[AUTH_API] raw data type: ${response.data.runtimeType}');
    return response.data['data'] as Map<String, dynamic>;
  }
}