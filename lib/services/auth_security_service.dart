import 'dart:async';
import 'package:flutter/material.dart'; // Importar para usar ValueNotifier
import 'package:get/get.dart'; // Import GetX

class AuthSecurityService {
  static final AuthSecurityService _instance = AuthSecurityService._internal();
  factory AuthSecurityService() => _instance;
  AuthSecurityService._internal();

  int _loginAttempts = 0;
  DateTime? _lastFailedAttempt;
  bool _isLocked = false;
  final int maxAttempts = 3; // Máximo de intentos antes de bloquear
  final Duration lockDuration = const Duration(seconds: 30); // Tiempo de bloqueo

  // Variable observable para el estado de bloqueo
  final isLoginLocked = false.obs;
  final remainingTime = 0.obs;
  final showCaptcha = false.obs;

  Timer? _lockTimer;

  Future<bool> canAttemptLogin() async {
    if (_isLocked) {
      if (_lastFailedAttempt != null) {
        final timeSinceLastAttempt = DateTime.now().difference(_lastFailedAttempt!);
        if (timeSinceLastAttempt >= lockDuration) {
          _resetAttempts();
          return true;
        }
        return false;
      }
    }
    return true;
  }

  void lockLogin() {
    _isLocked = true;
    isLoginLocked.value = true;
    _lastFailedAttempt = DateTime.now();
    
    // Iniciar el temporizador de 30 segundos
    remainingTime.value = 30;
    _lockTimer?.cancel();
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
        _resetAttempts();
      }
    });
  }

  void _resetAttempts() {
    _loginAttempts = 0;
    _isLocked = false;
    isLoginLocked.value = false;
    remainingTime.value = 0;
    showCaptcha.value = false;
    _lastFailedAttempt = null;
    _lockTimer?.cancel();
  }

  void resetAttempts() {
    _resetAttempts();
  }

  void resetCaptcha() {
    showCaptcha.value = false;
  }

  void incrementAttempts() {
    _loginAttempts++;
    if (_loginAttempts >= maxAttempts) {
      lockLogin();
    } else if (_loginAttempts > 0) {
      showCaptcha.value = true;
    }
  }

  Future<String?> attemptLogin(String email, String password) async {
    if (!await canAttemptLogin()) {
      final remainingSeconds = remainingTime.value;
      return 'Cuenta bloqueada. Intente nuevamente en $remainingSeconds segundos';
    }

    // Aquí iría tu lógica de autenticación real
    bool loginSuccess = false; // Reemplazar con tu lógica real
    
    if (!loginSuccess) {
      incrementAttempts();
      return 'Credenciales incorrectas. Intentos restantes: ${maxAttempts - _loginAttempts}';
    }

    _resetAttempts();
    return null; // null significa éxito
  }
}
