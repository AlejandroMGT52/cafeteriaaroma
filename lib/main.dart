// lib/main.dart
import 'package:flutter/material.dart';
import 'package:medical_app/src/pages/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/src/data/cart_manager.dart';
import 'package:medical_app/src/pages/home_page.dart';
import 'package:medical_app/src/pages/menu_page.dart';
import 'package:medical_app/src/pages/orders_page.dart';
import 'package:medical_app/src/pages/profile_page.dart';
import 'package:medical_app/src/pages/login_screen.dart';
import 'package:medical_app/src/pages/register_screen.dart';
import 'package:medical_app/src/pages/wrapper.dart';

// Imports de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  // 1. Asegura la inicialización de widgets
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase inicializado correctamente");
  } catch (e) {
    print("❌ Error al inicializar Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartManager()),
        // Aquí puedes agregar otros providers si los necesitas
      ],
      child: MaterialApp(
        title: 'Cafeteria MOC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
          primaryColor: const Color(0xFF8B4513),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8B4513),
          ),
        ),
        // La pantalla inicial será el Wrapper que maneja la autenticación
        initialRoute: 'wrapper',
        routes: {
          // Rutas principales
          'splash': (context) => const SplashScreen(),
          'wrapper': (context) => const AuthWrapper(),
          'home': (context) => const HomePage(),
          'menu': (context) => const MenuPage(),
          'orders': (context) => const OrdersPage(),
          'profile': (context) => const ProfilePage(),

          // Rutas de autenticación
          'login': (context) => const LoginScreen(),
          'register': (context) => const RegisterScreen(),
        },
      ),
    );
  }
}

// WRAPPER: Detecta automáticamente el estado de autenticación
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

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
                    'Cargando...',
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

        // Si hay error en la conexión
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
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Intentar recargar
                      Navigator.pushReplacementNamed(context, 'wrapper');
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        // Si hay un usuario autenticado, ir a HomePage
        if (snapshot.hasData && snapshot.data != null) {
          print("✅ Usuario autenticado: ${snapshot.data!.email}");
          return const HomePage();
        }

        // Si no hay usuario, mostrar LoginScreen
        print("⚠️ No hay usuario autenticado");
        return const LoginScreen();
      },
    );
  }
}