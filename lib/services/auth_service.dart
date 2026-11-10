// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'auth_api.dart';
import 'current_user.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  AuthResult.success()
      : success = true,
        errorMessage = null;
  AuthResult.failure(this.errorMessage) : success = false;
}

class AuthService {
  static final AuthApi _authApi = AuthApi();

  static Future<AuthResult> login(String email, String password) async {
    debugPrint('[AUTH_SERVICE] login called');
    try {
      final data = await _authApi.login(email: email, password: password);
      debugPrint('[AUTH_SERVICE] data received: $data');
      debugPrint('[AUTH_SERVICE] data runtimeType: ${data.runtimeType}');

      final prefs = await SharedPreferences.getInstance();
      debugPrint('[AUTH_SERVICE] setting token: ${data['token']}');
      await prefs.setString('token', data['token']);
      debugPrint(
          '[AUTH_SERVICE] setting refresh_token: ${data['refresh_token']}');
      await prefs.setString('refresh_token', data['refresh_token']);
      debugPrint(
          '[AUTH_SERVICE] setting personnel_id: ${data['personnel_id']} (${data['personnel_id'].runtimeType})');
      await prefs.setInt('personnel_id', data['personnel_id']);
      debugPrint('[AUTH_SERVICE] setting full_name: ${data['full_name']}');
      await prefs.setString('full_name', data['full_name']);

      CurrentUser.personnelId = data['personnel_id'];
      CurrentUser.fullName = data['full_name'];

      debugPrint('[AUTH_SERVICE] all done, returning success');
      return AuthResult.success();
    } on DioException catch (e) {
      debugPrint(
          '[AUTH_SERVICE] DioException: ${e.response?.statusCode} ${e.response?.data}');
      final message =
          e.response?.data['message'] ?? 'Login failed. Please try again.';
      return AuthResult.failure(message);
    } catch (e, stack) {
      debugPrint('[AUTH_SERVICE] UNEXPECTED ERROR: $e');
      debugPrint('[AUTH_SERVICE] STACK TRACE:\n$stack');
      return AuthResult.failure('Something went wrong.');
    }
  }

  static Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;

    CurrentUser.personnelId = prefs.getInt('personnel_id');
    CurrentUser.fullName = prefs.getString('full_name') ?? '';
    return true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    CurrentUser.personnelId = null;
    CurrentUser.fullName = '';
  }
}
