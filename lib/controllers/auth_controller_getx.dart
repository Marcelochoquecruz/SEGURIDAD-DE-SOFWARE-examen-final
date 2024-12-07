import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthControllerGetx extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final email = ''.obs;
  final password = ''.obs;
  final name = ''.obs;
  final confirmPassword = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final Rx<User?> user = Rx<User?>(null);

  // Validation variables
  final isEmailValid = false.obs;
  final isPasswordValid = false.obs;
  final isNameValid = false.obs;
  final isConfirmPasswordValid = false.obs;

  // Error messages
  final emailError = RxnString();
  final passwordError = RxnString();
  final nameError = RxnString();
  final confirmPasswordError = RxnString();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());

    // Add listeners for validation
    ever(email, validateEmail);
    ever(password, validatePassword);
    ever(name, validateName);
    ever(confirmPassword, validateConfirmPassword);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  bool validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'El correo es requerido';
      isEmailValid.value = false;
      return false;
    }
    
    // Your existing email validation logic
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      emailError.value = 'Correo electrónico inválido';
      isEmailValid.value = false;
      return false;
    }
    
    emailError.value = null;
    isEmailValid.value = true;
    return true;
  }

  bool validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'La contraseña es requerida';
      isPasswordValid.value = false;
      return false;
    } else if (value.length < 6) {
      passwordError.value = 'La contraseña debe tener al menos 6 caracteres';
      isPasswordValid.value = false;
      return false;
    } else {
      passwordError.value = null;
      isPasswordValid.value = true;
      validateConfirmPassword(confirmPassword.value);
      return true;
    }
  }

  void validateName(String value) {
    if (value.isEmpty) {
      nameError.value = 'El nombre es requerido';
      isNameValid.value = false;
    } else if (value.length < 3) {
      nameError.value = 'El nombre debe tener al menos 3 caracteres';
      isNameValid.value = false;
    } else {
      nameError.value = null;
      isNameValid.value = true;
    }
  }

  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      confirmPasswordError.value = 'Confirme su contraseña';
      isConfirmPasswordValid.value = false;
    } else if (value != password.value) {
      confirmPasswordError.value = 'Las contraseñas no coinciden';
      isConfirmPasswordValid.value = false;
    } else {
      confirmPasswordError.value = null;
      isConfirmPasswordValid.value = true;
    }
  }

  Future<void> login() async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );
      
      if (userCredential.user != null) {
        Get.offNamed('/welcome'); // Navigate to welcome screen
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error al iniciar sesión';
      if (e.code == 'user-not-found') {
        errorMessage = 'No existe usuario con este correo';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Contraseña incorrecta';
      }
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
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

  Future<void> signUp() async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );
      
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name.value.trim());
        Get.snackbar(
          'Éxito',
          'Cuenta creada exitosamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offNamed('/login');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error al crear la cuenta';
      if (e.code == 'weak-password') {
        errorMessage = 'La contraseña es muy débil';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Ya existe una cuenta con este correo';
      }
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al crear la cuenta: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cerrar sesión: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearFields() {
    email.value = '';
    password.value = '';
    name.value = '';
    confirmPassword.value = '';
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }
}
