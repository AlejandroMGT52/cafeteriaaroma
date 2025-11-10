import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importamos la lógica de gestión de estado del carrito
import 'package:medical_app/src/data/cart_manager.dart';

// Importamos todas las páginas de navegación
import 'package:medical_app/src/pages/splash_screen.dart';
import 'package:medical_app/src/pages/login_screen.dart';
import 'package:medical_app/src/pages/register_screen.dart';
import 'package:medical_app/src/pages/home_page.dart';
import 'package:medical_app/src/pages/menu_page.dart';
import 'package:medical_app/src/pages/orders_page.dart';
import 'package:medical_app/src/pages/profile_page.dart';

// Constante global para el costo de adicionales
const double addonCost = 0.50;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash',
      routes: {
        'splash': (context) => const SplashScreen(),
        'login': (context) => const LoginScreen(),
        'register': (context) => const RegisterScreen(),
        'home': (context) => const HomePage(),
        'menu': (context) => const MenuPage(),
        'orders': (context) => const OrdersPage(),
        'profile': (context) => const ProfilePage(),
      },
    );
  }
}