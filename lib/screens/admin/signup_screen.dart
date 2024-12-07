import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller_getx.dart';
import 'package:animate_do/animate_do.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      child: Card(
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
                                  Icons.person_add,
                                  size: 80,
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Crear Cuenta',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Obx(() => TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa tu nombre';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => controller.name.value = value,
                                  decoration: InputDecoration(
                                    labelText: 'Nombre Completo',
                                    prefixIcon: const Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorText: controller.nameError.value,
                                  ),
                                )),
                                const SizedBox(height: 20),
                                Obx(() => TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty || !value.contains('@')) {
                                      return 'Por favor ingresa un correo electrónico válido';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => controller.email.value = value,
                                  decoration: InputDecoration(
                                    labelText: 'Correo electrónico',
                                    prefixIcon: const Icon(Icons.email),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorText: controller.emailError.value,
                                  ),
                                )),
                                const SizedBox(height: 20),
                                Obx(() => TextFormField(
                                  validator: (value) {
                                    if (value == null || value.length < 8) {
                                      return 'La contraseña debe tener al menos 8 caracteres';
                                    }
                                    return null;
                                  },
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
                                )),
                                const SizedBox(height: 20),
                                Obx(() => TextFormField(
                                  validator: (value) {
                                    if (value != controller.password.value) {
                                      return 'Las contraseñas no coinciden';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => controller.confirmPassword.value = value,
                                  obscureText: !controller.isConfirmPasswordVisible.value,
                                  decoration: InputDecoration(
                                    labelText: 'Confirmar Contraseña',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isConfirmPasswordVisible.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: controller.toggleConfirmPasswordVisibility,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorText: controller.confirmPasswordError.value,
                                  ),
                                )),
                                const SizedBox(height: 30),
                                Obx(() => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: (controller.isEmailValid.value && 
                                                      controller.isPasswordValid.value &&
                                                      controller.isNameValid.value &&
                                                      controller.isConfirmPasswordValid.value)
                                          ? Colors.blue
                                          : Colors.grey,
                                  ),
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () {
                                          if (_formKey.currentState!.validate()) {
                                            controller.signUp();
                                          }
                                        },
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          'Crear Cuenta',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                )),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '¿Ya tienes una cuenta?',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text(
                                        'Iniciar Sesión',
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
