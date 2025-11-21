// lib/src/pages/wrapper.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_app/src/pages/home_page.dart';
import 'package:medical_app/src/pages/login_screen.dart';

/// Wrapper que maneja automáticamente el estado de autenticación
/// Si hay un usuario autenticado → HomePage
/// Si NO hay usuario → LoginScreen
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Mientras se verifica el estado de autenticación
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFf5ebe0),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF8B4513),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Verificando sesión...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5C4033),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Si hay error en la autenticación
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFFf5ebe0),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Error de autenticación',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                    ),
                    child: const Text('Ir al Login'),
                  ),
                ],
              ),
            ),
          );
        }

        // Si hay un usuario autenticado → HomePage
        if (snapshot.hasData && snapshot.data != null) {
          print("✅ Usuario autenticado: ${snapshot.data!.email}");
          return const HomePage();
        }

        // Si NO hay usuario → LoginScreen
        print("⚠️ No hay usuario autenticado, mostrando LoginScreen");
        return const LoginScreen();
      },
    );
  }
}