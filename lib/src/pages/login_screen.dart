import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Para controlar el estado de carga
  final Color primaryColor = const Color(0xFF8B4513);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Función de inicio de sesión con Firebase Auth
  void _submitLogin() async {
    // Validar el formulario
    if (!_formKey.currentState!.validate()) return;

    // Evitar múltiples clics
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Mostrar indicador de carga
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando sesión con: ${_emailController.text.trim()}...'),
        backgroundColor: primaryColor,
        duration: const Duration(seconds: 1),
      ),
    );

    try {
      // Iniciar sesión con Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      print("✅ Login exitoso: ${_emailController.text.trim()}");

      // Ocultar snackbar de carga
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Inicio de sesión exitoso!'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 800),
        ),
      );

      // Esperar un momento para que el usuario vea el mensaje
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // *** SOLUCIÓN: Navegar al wrapper y limpiar el stack de navegación ***
      Navigator.of(context).pushNamedAndRemoveUntil(
        'wrapper',
        (route) => false, // Elimina todas las rutas anteriores
      );

    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      // Mapear los errores comunes de Firebase
      String message;
      if (e.code == 'user-not-found') {
        message = 'No se encontró un usuario con ese correo.';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta.';
      } else if (e.code == 'invalid-email') {
        message = 'El formato del correo electrónico es inválido.';
      } else if (e.code == 'user-disabled') {
        message = 'Esta cuenta ha sido deshabilitada.';
      } else if (e.code == 'too-many-requests') {
        message = 'Demasiados intentos. Intenta más tarde.';
      } else if (e.code == 'network-request-failed') {
        message = 'Error de conexión. Verifica tu internet.';
      } else if (e.code == 'invalid-credential') {
        message = 'Credenciales inválidas. Verifica tu correo y contraseña.';
      } else {
        message = 'Error de inicio de sesión: ${e.message}';
      }

      print("❌ FirebaseAuthException: ${e.code} - ${e.message}");

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print("❌ Error Inesperado (Login): $e");

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error inesperado. Intenta más tarde.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5ebe0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo superior y Títulos
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.coffee, size: 50, color: Color(0xFF8B4513)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Coffee Shop",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Bienvenido de nuevo",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.brown.shade600,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),

                // 1. Campo de Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  decoration: _inputDecoration(
                    labelText: 'Correo Electrónico',
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Ingresa un correo válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // 2. Campo de Contraseña
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  enabled: !_isLoading,
                  decoration: _inputDecoration(
                    labelText: 'Contraseña',
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña.';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Botón de Login
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitLogin,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 25),

                // Botón para ir al registro
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.brown.shade600, width: 1.5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pushNamed(context, 'register');
                        },
                  child: Text(
                    "Registrarse",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Texto de ayuda
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Función de ayuda aún no implementada')),
                          );
                        },
                  child: const Text(
                    "¿Necesitas ayuda?",
                    style: TextStyle(color: Color(0xFF8B4513), fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Función auxiliar para decorar los campos de texto
  InputDecoration _inputDecoration({
    required String labelText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: primaryColor),
      suffixIcon: suffixIcon,
      labelStyle: const TextStyle(color: Color(0xFF5C4033)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }
}