import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_security_service.dart';

class AuthControllerGetx extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _securityService = AuthSecurityService();
  final email = ''.obs;
  final password = ''.obs;
  final name = ''.obs;
  final confirmPassword = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final Rx<User?> user = Rx<User?>(null);
  final isLoginLocked = false.obs;
  final remainingLockTime = 0.obs;
  final isLoginButtonEnabled = true.obs;
  final loginMessage = ''.obs;

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
    ever(password, validatePassword);
    // Bind the security service values
    ever(_securityService.isLoginLocked.obs, (locked) {
      isLoginLocked.value = locked.value;
      isLoginButtonEnabled.value = !locked.value;
    });
    ever(_securityService.remainingTime.obs, (time) {
      remainingLockTime.value = time.value;
      if (time.value > 0) {
        loginMessage.value = 'Botón bloqueado. Espere ${time.value} segundos';
      } else {
        loginMessage.value = '';
      }
    });
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
    }
    
    List<String> requirements = [];
    
    if (value.length < 8) {
      requirements.add('al menos 8 caracteres');
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      requirements.add('una letra mayúscula');
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      requirements.add('una letra minúscula');
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      requirements.add('un número');
    }
    
    if (requirements.isNotEmpty) {
      passwordError.value = 'La contraseña debe contener: ${requirements.join(", ")}';
      isPasswordValid.value = false;
      return false;
    }
    
    passwordError.value = null;
    isPasswordValid.value = true;
    validateConfirmPassword(confirmPassword.value);
    return true;
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
    if (isLoginLocked.value) {
      Get.snackbar(
        'Acceso bloqueado',
        'Espere ${remainingLockTime.value} segundos antes de intentar nuevamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      String? securityCheck = await _securityService.attemptLogin(email.value, password.value);
      
      if (securityCheck != null) {
        // Si hay un mensaje de seguridad (error), mostrar al usuario
        Get.snackbar(
          'Error de autenticación',
          securityCheck,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );
      
      // Si el login es exitoso, resetear los intentos
      _securityService.resetAttempts(); 
      Get.offAllNamed('/welcome');
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error de autenticación';
      
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No existe una cuenta con este correo.';
          break;
        case 'wrong-password':
          errorMessage = 'Contraseña incorrecta.';
          break;
        case 'invalid-email':
          errorMessage = 'Correo electrónico inválido.';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
      }
      
      // Intentar el login con el servicio de seguridad
      await _securityService.attemptLogin(email.value, password.value);
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
