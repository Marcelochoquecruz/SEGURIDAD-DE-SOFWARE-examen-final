import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthControllerGetx extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> login() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar(
        'Error',
        'Las contraseñas no coinciden',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      // Aquí implementaremos la lógica de autenticación
      await Future.delayed(const Duration(seconds: 2)); // Simulación de carga

      // Por ahora, solo mostraremos un mensaje de éxito
      Get.snackbar(
        'Éxito',
        'Inicio de sesión exitoso',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // TODO: Implementar navegación a dashboard
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al iniciar sesión: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool validateEmail(String value) {
    return GetUtils.isEmail(value);
  }

  bool validatePassword(String value) {
    return value.length >= 6;
  }

  void clearFields() {
    email.value = '';
    password.value = '';
    confirmPassword.value = '';
  }
}
