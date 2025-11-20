import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  // Paleta de colores consistente
  final Color primaryColor = const Color(0xFF8B4513);
  final Color darkTextColor = const Color(0xFF5C4033);

  @override
  Widget build(BuildContext context) {
    // Definición de controladores y clave de formulario
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // Función de registro con Firebase Auth y Firestore
    Future<void> _submitRegister() async {
      if (!_formKey.currentState!.validate()) return;

      // Mostrar indicador de carga
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrando a ${emailController.text.trim()}...'),
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 1),
        ),
      );

      try {
        // 1. --- LÓGICA DE FIREBASE AUTH (CREAR USUARIO) ---
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(), // ⬅️ CORRECCIÓN CLAVE
        );

        // Opcional: Actualizar nombre de visualización en Auth
        await userCredential.user!.updateDisplayName(nameController.text.trim());

        // 2. --- LÓGICA DE FIRESTORE (CREAR DOCUMENTO DE PERFIL) ---
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'loyaltyPoints': 0, // Inicializa los puntos en 0
          'createdAt': FieldValue.serverTimestamp(),
        });
        // --------------------------------------------------------

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso. ¡Bienvenido/a!'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 1500),
          ),
        );

        // Navegar a la pantalla de inicio después del registro exitoso
        Navigator.pushReplacementNamed(context, 'home');

      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'weak-password') {
          message = 'La contraseña proporcionada es demasiado débil.';
        } else if (e.code == 'email-already-in-use') {
          message = 'Ya existe una cuenta para esa dirección de correo.';
        } else {
          message = 'Error de registro: ${e.message}';
        }

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ocurrió un error inesperado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }


    return Scaffold(
      backgroundColor: const Color(0xFFf5ebe0), // Fondo crema cálido
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          child: Form( // Añadir Form para la validación
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo superior (Simulado)
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      // backgroundImage: AssetImage("assets/logo.png"), // Tu imagen real
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
                    if (value == null || value.trim().isEmpty) { // ⬅️ VALIDACIÓN MEJORADA
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
                    if (value == null || value.trim().isEmpty || !value.contains('@')) { // ⬅️ VALIDACIÓN MEJORADA
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
                    if (value == null || value.trim().length < 6) { // ⬅️ VALIDACIÓN MEJORADA
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
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _submitRegister, // Llama a la función corregida
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
                        const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
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
                          content: Text('Función de ayuda aún no implementada')),
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

  InputDecoration _inputDecoration({required String labelText, required IconData icon}) {
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