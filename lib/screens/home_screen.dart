import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';
import 'admin/login_screen.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.1),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      child: const CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.school,
                          size: 100,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      child: const Text(
                        'SEGURIDAD DE SOFTWARE',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInDown(
                      delay: const Duration(milliseconds: 400),
                      child: const Text(
                        'INF-633',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInDown(
                      delay: const Duration(milliseconds: 600),
                      child: const Text(
                        'Docente: M.Sc. Huascar Fedor Gonzales Guzman',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInDown(
                      delay: const Duration(milliseconds: 700),
                      child: const Text(
                        'Auxiliar: Univ. Job Molina Abasto',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInDown(
                      delay: const Duration(milliseconds: 800),
                      child: const Text(
                        'EXAMEN FINAL',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInDown(
                      delay: const Duration(milliseconds: 1000),
                      child: const Text(
                        'Estudiante: Univ. Marcelo Choque Cruz',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInDown(
                      delay: const Duration(milliseconds: 1100),
                      child: Text(
                        'Fecha de presentación: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeInDown(
                      delay: const Duration(milliseconds: 1300),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Ingresar como Administrador',
                          style: TextStyle(color: Colors.blue),
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
