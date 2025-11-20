// lib/main.dart (Actualizado para inicialización de Firebase)
import 'package:flutter/material.dart';
import 'package:medical_app/src/pages/splash_screen.dart';
import 'package:provider/provider.dart'; // Corregido: Importación de Provider
import 'package:medical_app/src/data/cart_manager.dart'; // Asume la existencia
import 'package:medical_app/src/pages/home_page.dart'; // Asume la existencia
import 'package:medical_app/src/pages/menu_page.dart'; // Asume la existencia
import 'package:medical_app/src/pages/orders_page.dart'; // Asume la existencia
import 'package:medical_app/src/pages/profile_page.dart'; // Asume la existencia
import 'package:medical_app/src/pages/login_screen.dart'; // Asume la existencia
import 'package:medical_app/src/pages/register_screen.dart'; // Asume la existencia

// Imports de Firebase
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; // Asume que este archivo existe y está generado

// Importación del Wrapper
import 'package:medical_app/src/pages/wrapper.dart';


void main() async { 
  // 1. Asegura la inicialización de widgets
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inicializar Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, 
    );
  } catch (e) {
    // Manejo de errores si Firebase no puede inicializarse
    print("Error al inicializar Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Usar MultiProvider o envolver con un solo ChangeNotifierProvider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartManager()),
        // Aquí puedes agregar otros providers, como AuthService, si lo tienes.
      ],
      child: MaterialApp(
        title: 'Cafeteria MOC',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        // 4. Establecer 'wrapper' como la ruta inicial
        initialRoute: 'splash', 
        routes: {
          // Rutas principales
          'splash': (context) => const SplashScreen(), // El punto de entrada de la autenticación
          'home': (context) => const HomePage(), 
          'menu': (context) => const MenuPage(), 
          'orders': (context) => const OrdersPage(), 
          'profile': (context) => const ProfilePage(),
          
          // Rutas de autenticación
          'login': (context) => const LoginScreen(),
          'register': (context) => const RegisterScreen(),
          
          // Otras rutas
          // Nota: checkout_page.dart y order_tracking_page.dart generalmente
          // se navegan usando MaterialPageRoute y no rutas con nombre, 
          // ya que requieren argumentos (orderId, cartItems).
        },
      ),
    );
  }
}