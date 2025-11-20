import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ⬅️ ¡NUEVO! Importar Firestore

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Paleta de colores consistente
  final Color primaryColor = const Color(0xFF8B4513); // Marrón Café Tostado
  final Color accentColor = const Color(0xFFD2B48C); // Beige/Ocre
  final Color darkTextColor = const Color(0xFF5C4033); // Marrón Oscuro

  // Función de cerrar sesión (mantenemos la lógica de Auth)
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión cerrada. ¡Vuelve pronto!'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 1500),
        ),
      );
      
      // Navegar a la pantalla de login (reemplazando todas las rutas anteriores)
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario actual de Firebase Auth
    final User? user = FirebaseAuth.instance.currentUser;
    
    // Si no hay usuario logueado, redirigir al login
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Redirección segura si el usuario no está autenticado
        Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                  const SnackBar(content: Text('Configuración (simulado)')),
                );
            },
          ),
        ],
      ),
      
      // Utilizamos StreamBuilder para obtener los datos de Firestore en tiempo real
      body: StreamBuilder<DocumentSnapshot>(
        // El stream apunta al documento del usuario en la colección 'users'
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          // Estado de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF8B4513)));
          }

          // Manejo de errores
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar el perfil: ${snapshot.error}'));
          }

          // Si no hay datos (p.ej., el documento fue borrado)
          if (!snapshot.hasData || !snapshot.data!.exists || snapshot.data!.data() == null) {
            return const Center(child: Text('Error: No se encontraron datos de perfil en la base de datos.'));
          }

          // ⬅️ EXTRACCIÓN DE DATOS REALES DE FIRESTORE 
          final data = snapshot.data!.data() as Map<String, dynamic>;
          
          final String userName = data['name'] ?? user.displayName ?? 'Usuario de Cafetería';
          final String userEmail = data['email'] ?? user.email ?? 'No disponible';
          // Se asegura de que loyaltyPoints sea un entero
          final int loyaltyPoints = (data['loyaltyPoints'] is num) ? data['loyaltyPoints'].toInt() : 0; 

          // Lógica para la imagen (placeholder con inicial del nombre)
          final String profileImageUrl = 'https://placehold.co/100x100/FAF0E6/5C4033?text=${userName.isNotEmpty ? userName.substring(0, 1) : '?'}';
          // -------------------------------------------------------------

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Sección de Datos del Usuario (ahora con datos REALES)
                _buildProfileHeader(userName, userEmail, profileImageUrl),
                const SizedBox(height: 30),
                
                // Sección de Puntos de Lealtad (ahora con datos REALES)
                _buildLoyaltyCard(loyaltyPoints),
                const SizedBox(height: 30),
                
                // Opciones del Perfil
                _buildProfileOption(
                  context, 
                  icon: Icons.receipt_long_outlined, 
                  title: 'Historial de Pedidos', 
                  onTap: () => Navigator.pushReplacementNamed(context, 'orders'),
                ),
                _buildProfileOption(
                  context, 
                  icon: Icons.location_on_outlined, 
                  title: 'Direcciones de Entrega', 
                  onTap: () => _showSimulatedAction(context, 'Direcciones'),
                ),
                _buildProfileOption(
                  context, 
                  icon: Icons.credit_card_outlined, 
                  title: 'Métodos de Pago', 
                  onTap: () => _showSimulatedAction(context, 'Pagos'),
                ),
                _buildProfileOption(
                  context, 
                  icon: Icons.help_outline, 
                  title: 'Ayuda y Soporte', 
                  onTap: () => _showSimulatedAction(context, 'Ayuda'),
                ),
                const SizedBox(height: 40),
                
                // Botón de Cerrar Sesión REAL
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _logout(context), 
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text('Cerrar Sesión'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 4),
    );
  }

  // --- Funciones de construcción de widgets (Mantenidas) ---

  Widget _buildProfileHeader(String name, String email, String imageUrl) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: accentColor,
          backgroundImage: NetworkImage(imageUrl),
          child: Text(
            name.substring(0, 1),
            style: TextStyle(fontSize: 30, color: darkTextColor, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoyaltyCard(int points) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: primaryColor, size: 30),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puntos de Lealtad',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Text(
                    '$points Puntos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      leading: Icon(icon, color: primaryColor, size: 28),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: darkTextColor),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
  
  void _showSimulatedAction(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action (Simulado)'), duration: const Duration(seconds: 1)),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
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