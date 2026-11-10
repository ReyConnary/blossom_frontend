// lib/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../pages/home_page.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

Future<void> login(String email, String password) async {
  debugPrint('[LOGIN] called with email="$email" password="$password"');
  debugPrint('[LOGIN] email.isEmpty=${email.isEmpty} password.isEmpty=${password.isEmpty}');

  if (email.isEmpty || password.isEmpty) {
    debugPrint('[LOGIN] blocked by empty check');
    errorMessage.value = 'Please enter email and password';
    return;
  }

  debugPrint('[LOGIN] passed empty check, calling AuthService.login');
  isLoading.value = true;
  errorMessage.value = null;

  final result = await AuthService.login(email, password);

  debugPrint('[LOGIN] AuthService returned success=${result.success} error=${result.errorMessage}');

  isLoading.value = false;

  if (result.success) {
    debugPrint('[LOGIN] navigating to HomePage');
    Get.offAll(() => const HomePage());
  } else {
    errorMessage.value = result.errorMessage;
  }
}
}