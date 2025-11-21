import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool _isLoading = false; // Estado de carga

  final Color primaryColor = const Color(0xFF8B4513);
  final Color darkTextColor = const Color(0xFF5C4033);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Función de registro con Firebase Auth y Firestore
  Future<void> _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Evitar múltiples clics
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Mostrar indicador de carga
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registrando a ${emailController.text.trim()}...'),
        backgroundColor: primaryColor,
        duration: const Duration(seconds: 1),
      ),
    );

    try {
      // 1. Crear usuario en Firebase Auth
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. Actualizar nombre de visualización
      await userCredential.user!.updateDisplayName(nameController.text.trim());

      // 3. Crear documento en Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'loyaltyPoints': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) return;

      print("✅ Usuario registrado exitosamente: ${userCredential.user!.email}");

      // *** IMPORTANTE: Cerrar sesión después del registro ***
      // Esto evita que el AuthWrapper redirija automáticamente al HomePage
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      // Mostrar diálogo de éxito con instrucciones
      showDialog(
        context: context,
        barrierDismissible: false, // No se puede cerrar tocando fuera
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                SizedBox(width: 10),
                Text('¡Registro Exitoso!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tu cuenta ha sido creada correctamente.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Por favor, inicia sesión con tus credenciales.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                  // Navegar al login y limpiar el stack
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    'login',
                    (route) => false,
                  );
                },
                child: Text(
                  'Ir a Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );

    } on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException: ${e.code} - ${e.message}");

      String message;
      if (e.code == 'weak-password') {
        message = 'La contraseña es demasiado débil (mínimo 6 caracteres).';
      } else if (e.code == 'email-already-in-use') {
        message = 'Ya existe una cuenta con este correo.';
      } else if (e.code == 'invalid-email') {
        message = 'El formato del correo es inválido.';
      } else if (e.code == 'network-request-failed') {
        message = 'Error de conexión. Verifica tu internet.';
      } else {
        message = 'Error de registro: ${e.message}';
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } on FirebaseException catch (e) {
      print("❌ FirebaseException (Firestore): ${e.code} - ${e.message}");

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar datos: ${e.message}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print("❌ Error Inesperado (Registro): $e");

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error inesperado. Verifica tu conexión.'),
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
                // Logo superior
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.coffee,
                          size: 50, color: Color(0xFF8B4513)),
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
                      "Crear Cuenta",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.brown.shade600,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),

                // 1. Campo de Nombre
                TextFormField(
                  controller: nameController,
                  decoration: _inputDecoration(
                    labelText: 'Nombre Completo',
                    icon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, ingresa tu nombre.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // 2. Campo de Email
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(
                    labelText: 'Correo Electrónico',
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('@')) {
                      return 'Ingresa un correo válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // 3. Campo de Contraseña
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: _inputDecoration(
                    labelText: 'Contraseña',
                    icon: Icons.lock_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Botón de Registro
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
                  onPressed: _submitRegister,
                  child: const Text(
                    "Crear Cuenta",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 18),

                // Botón para ir al login
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.brown.shade600, width: 1.5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Navegar al login
                    Navigator.pushReplacementNamed(context, 'login');
                  },
                  child: Text(
                    "¿Ya tienes una cuenta? Inicia sesión",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Texto de ayuda
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Función de ayuda aún no implementada')),
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

  InputDecoration _inputDecoration(
      {required String labelText, required IconData icon}) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: primaryColor),
      labelStyle: TextStyle(color: darkTextColor),
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