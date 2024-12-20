import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:flutter_captcha/flutter_captcha.dart';
import '../../controllers/auth_controller_getx.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthControllerGetx controller = Get.put(AuthControllerGetx());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.admin_panel_settings,
                              size: 80,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Acceso Administrativo',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              onChanged: (value) => controller.email.value = value,
                              decoration: InputDecoration(
                                labelText: 'Correo electrónico',
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su correo';
                                }
                                if (!controller.validateEmail(value)) {
                                  return 'Por favor ingrese un correo válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Obx(() => TextFormField(
                              onChanged: (value) => controller.password.value = value,
                              obscureText: !controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText: controller.passwordError.value,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese su contraseña';
                                }
                                if (value.length > 8) {
                                  return 'La contraseña debe tener máximo 8 caracteres';
                                }
                                return null;
                              },
                            )),
                            Obx(() => controller._securityService.showCaptcha.value
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: FlutterCaptcha(
                                      onSuccess: () {
                                        controller._securityService.resetCaptcha();
                                      },
                                    ),
                                  )
                                : const SizedBox()),
                            const SizedBox(height: 20),
                            Obx(() => Text(
                              controller.loginMessage.value,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            )),
                            const SizedBox(height: 20),
                            Obx(() => ElevatedButton(
                              onPressed: controller.isLoginButtonEnabled.value
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        await controller.login();
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue.shade900,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 15,
                                ),
                              ),
                              child: const Text(
                                'Iniciar Sesión',
                                style: TextStyle(fontSize: 18),
                              ),
                            )),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '¿No tienes una cuenta?',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextButton(
                                  onPressed: () => Get.toNamed('/signup'),
                                  child: const Text(
                                    'Crear cuenta',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      controller.clearFields();
                      Get.back();
                    },
                    child: const Text(
                      'Volver al Inicio',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
