import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Paleta de colores consistente
  final Color primaryColor = const Color(0xFF8B4513); // Marrón Café Tostado
  final Color accentColor = const Color(0xFFD2B48C); // Beige/Ocre
  final Color darkTextColor = const Color(0xFF5C4033); // Marrón Oscuro

  // Datos simulados del usuario
  final String userName = 'Andrea G.';
  final String userEmail = 'andrea.g@ejemplo.com';
  final String profileImageUrl = 'https://placehold.co/100x100/FAF0E6/5C4033?text=AG';
  final int loyaltyPoints = 350;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.w900,
            fontSize: 26,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: darkTextColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abriendo Configuración...')),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // --- Sección 1: Cabecera del Usuario ---
              _buildUserProfileHeader(),
              const SizedBox(height: 24),

              // --- Sección 2: Puntos de Fidelidad (Recompensas) ---
              _buildLoyaltyCard(context),
              const SizedBox(height: 30),

              // --- Sección 3: Opciones de Navegación Rápida ---
              _buildOptionTile(
                context, 
                icon: Icons.receipt_long, 
                title: 'Historial de Pedidos', 
                route: 'orders',
              ),
              _buildOptionTile(
                context, 
                icon: Icons.favorite_border, 
                title: 'Mis Favoritos',
              ),
              _buildOptionTile(
                context, 
                icon: Icons.wallet_outlined, 
                title: 'Métodos de Pago',
              ),
              _buildOptionTile(
                context, 
                icon: Icons.location_on_outlined, 
                title: 'Direcciones Guardadas',
              ),
              
              const SizedBox(height: 30),

              // --- Botón de Cerrar Sesión ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cerrando Sesión...')),
                    );
                    Navigator.pushReplacementNamed(context, 'login'); // Redirigir al login
                  },
                  icon: const Icon(Icons.logout, size: 24),
                  label: const Text('Cerrar Sesión'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[700],
                    side: BorderSide(color: Colors.red[300]!, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // --- Widgets de Componentes ---

  Widget _buildUserProfileHeader() {
    return Column(
      children: [
        // Avatar del Usuario
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accentColor, width: 3),
            image: DecorationImage(
              image: NetworkImage(profileImageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Nombre del Usuario
        Text(
          userName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: darkTextColor,
          ),
        ),
        const SizedBox(height: 4),
        // Correo del Usuario
        Text(
          userEmail,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoyaltyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: primaryColor, // Fondo Marrón Tostado
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tus Puntos Aroma',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$loyaltyPoints Puntos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '¡A solo ${500 - loyaltyPoints} para un café gratis!',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // Icono de Puntos
          const Icon(
            Icons.star,
            color: Colors.white,
            size: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, {required IconData icon, required String title, String? route}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          if (route != null) {
            Navigator.pushNamed(context, route);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Abriendo ${title}...')),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18, color: darkTextColor),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  // Replicando el BottomNavBar de HomePage para mantener la coherencia
  Widget _buildBottomNavBar(BuildContext context) {
    const int currentIndex = 4; // 'profile' es el índice 4
    
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor, 
      unselectedItemColor: Colors.grey[400],
      showUnselectedLabels: false,
      onTap: (index) {
        String routeName;
        switch (index) {
          case 0:
            routeName = 'home';
            break;
          case 1:
            routeName = 'menu';
            break;
          case 2:
            routeName = 'orders';
            break;
          case 3:
            routeName = 'orders';
            break;
          case 4:
            routeName = 'profile';
            break;
          default:
            return;
        }
        if (routeName != ModalRoute.of(context)?.settings.name) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.coffee_outlined),
          activeIcon: Icon(Icons.coffee),
          label: 'Menú',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: 'Carrito',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}