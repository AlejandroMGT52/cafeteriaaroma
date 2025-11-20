// lib/src/pages/orders_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/src/data/cart_manager.dart';
import 'checkout_page.dart';

// --- Imports de Firebase y Servicios ---
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/order_service.dart';
import '../data/models/order_model.dart';
import 'order_tracking_page.dart'; // Para la navegación a rastreo
// ----------------------------------------

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF8B4513);
  final Color accentColor = const Color(0xFFD2B48C);
  final Color darkTextColor = const Color(0xFF5C4033);

  // --- Instancias de Servicios ---
  final OrderService _orderService = OrderService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // ------------------------------

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Mis Pedidos',
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.w900,
            fontSize: 26,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey[400],
          indicatorColor: primaryColor,
          indicatorWeight: 4.0,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Carrito'),
            Tab(text: 'Activos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCartView(context),
          _buildActiveOrdersView(context), // Vista con StreamBuilder implementado
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Vista del Carrito (sin cambios)
  Widget _buildCartView(BuildContext context) {
    return Consumer<CartManager>(
      builder: (context, cartManager, child) {
        if (cartManager.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  '¡Tu carrito está vacío!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[400]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Agrega productos desde el menú',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'menu');
                  },
                  icon: const Icon(Icons.coffee),
                  label: const Text('Ver Menú'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartManager.items.length,
                itemBuilder: (context, index) {
                  final item = cartManager.items[index];
                  return _buildCartItemCard(context, item, cartManager);
                },
              ),
            ),
            _buildCartSummary(context, cartManager),
          ],
        );
      },
    );
  }

  // Tarjeta de item en el carrito (sin cambios)
  Widget _buildCartItemCard(BuildContext context, CartItem item, CartManager cartManager) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen del producto
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.coffee, color: primaryColor, size: 30),
            ),
            const SizedBox(width: 12),
            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Precio base: ${item.price}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  if (item.addons.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Extras: ${item.addons.join(", ")}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    'Cantidad: ${item.quantity}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ],
              ),
            ),
            // Precio total y botón eliminar
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: () {
                    cartManager.removeItem(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto eliminado del carrito'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Resumen del carrito y botón de pago (sin cambios)
  Widget _buildCartSummary(BuildContext context, CartManager cartManager) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal:',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                Text(
                  '\$${cartManager.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Envío:',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                Text(
                  '\$2.50',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkTextColor),
                ),
                Text(
                  '\$${(cartManager.totalPrice + 2.50).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Ir a página de checkout
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        cartItems: cartManager.items,
                        total: cartManager.totalPrice + 2.50,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: const Text(
                  'Proceder al Pago',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Vista de pedidos activos (USO DE FIREBASE) ---
  Widget _buildActiveOrdersView(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      // Manejo si no hay usuario logueado
      return Center(
        child: _buildEmptyState(
          Icons.lock_outline,
          'Inicia sesión para ver tus pedidos',
          'Tus pedidos activos aparecerán aquí.',
        ),
      );
    }

    // StreamBuilder para obtener la lista de pedidos en tiempo real
    return StreamBuilder<List<OrderModel>>(
      stream: _orderService.getOrdersStreamForUser(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: _buildEmptyState(
              Icons.error_outline,
              'Error al cargar pedidos',
              'Detalles: ${snapshot.error}',
            ),
          );
        }

        final orders = snapshot.data;

        if (orders == null || orders.isEmpty) {
          return Center(
            child: _buildEmptyState(
              Icons.receipt_long_outlined,
              'No tienes pedidos activos',
              'Tus pedidos aparecerán aquí una vez finalizado el pago.',
            ),
          );
        }

        // Mostrar la lista de pedidos
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return _buildOrderListCard(context, order);
          },
        );
      },
    );
  }
  
  // Tarjeta de pedido individual
  Widget _buildOrderListCard(BuildContext context, OrderModel order) {
    String formattedDate = 
      '${order.orderDate.toDate().day}/${order.orderDate.toDate().month} ${order.orderDate.toDate().hour}:${order.orderDate.toDate().minute.toString().padLeft(2, '0')}';
      
    // Determinar color de estado
    Color statusColor;
    switch (order.status) {
      case 'Entregado':
        statusColor = Colors.green;
        break;
      case 'Cancelado':
        statusColor = Colors.red;
        break;
      case 'Pendiente':
      case 'Preparando':
      case 'En Camino':
      default:
        statusColor = primaryColor;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navegar a la página de seguimiento
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderTrackingPage(orderId: order.id!),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pedido #${order.id!.substring(0, 8)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                  Text(
                    order.status,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        '\$${order.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Fecha:',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: darkTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Items: ${order.items.map((e) => e.name).join(', ')}',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Widget de estado vacío/error
  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[400]),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      );
  }


  Widget _buildBottomNavBar(BuildContext context) {
    const int currentIndex = 2;

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
          case 3: // Si presiona Pedidos/Carrito, se queda en esta vista
            return; 
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