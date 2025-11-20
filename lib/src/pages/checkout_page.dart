// lib/src/pages/checkout_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/src/data/cart_manager.dart';
import 'order_tracking_page.dart';

// --- Imports de Firebase y Servicios ---
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para Timestamp
import '../data/services/order_service.dart';
import '../data/models/order_model.dart';
// ----------------------------------------

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double total;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final Color primaryColor = const Color(0xFF8B4513);
  final Color accentColor = const Color(0xFFD2B48C);
  final Color darkTextColor = const Color(0xFF5C4033);

  String selectedPaymentMethod = 'Tarjeta';
  String deliveryAddress = 'Calle Principal 123, Quito';
  bool isProcessing = false;

  // --- Instancias de Servicios ---
  final OrderService _orderService = OrderService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // ------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Finalizar Pedido',
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Dirección de Entrega'),
            _buildAddressCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Método de Pago'),
            _buildPaymentMethods(),
            const SizedBox(height: 24),
            _buildSectionTitle('Resumen del Pedido'),
            _buildOrderSummary(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Pagar \$${widget.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkTextColor,
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.location_on, color: primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Entregar en:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deliveryAddress,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cambiar dirección (simulado)')),
                );
              },
              icon: const Icon(Icons.edit_outlined),
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        _buildPaymentOption('Tarjeta', Icons.credit_card),
        const SizedBox(height: 12),
        _buildPaymentOption('Efectivo', Icons.money),
        const SizedBox(height: 12),
        _buildPaymentOption('PayPal', Icons.payment),
      ],
    );
  }

  Widget _buildPaymentOption(String method, IconData icon) {
    final isSelected = selectedPaymentMethod == method;
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? primaryColor : Colors.grey[600], size: 28),
            const SizedBox(width: 16),
            Text(
              method,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? darkTextColor : Colors.grey[700],
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: primaryColor, size: 24)
            else
              Icon(Icons.circle_outlined, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    // Calculamos el subtotal asumiendo que el envío es fijo de $2.50
    final subtotal = widget.total - 2.50; 
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildSummaryRow('Envío', '\$2.50'),
            const SizedBox(height: 8),
            _buildSummaryRow('Impuestos', '\$0.00'),
            const Divider(height: 24),
            _buildSummaryRow(
              'Total',
              '\$${widget.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? darkTextColor : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
            color: isTotal ? primaryColor : darkTextColor,
          ),
        ),
      ],
    );
  }

  // --- Lógica REAL de Procesamiento de Pedido con Firebase ---
  Future<void> _processPayment() async {
    final user = _auth.currentUser;

    if (user == null) {
      _showErrorDialog('Usuario no autenticado', 'Por favor, inicia sesión para completar tu pedido.');
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      // 1. Mapear CartItems a OrderItems
      final List<OrderItem> orderItems = widget.cartItems.map((cartItem) {
        // CORRECCIÓN: Asegurarse de que el precio sea de tipo double. 
        // Asumimos que cartItem.price es una cadena que contiene el valor numérico.
        final double itemPrice = double.tryParse(cartItem.price.toString().replaceAll('\$', '').trim()) ?? 0.0;
        
        return OrderItem(
          productId: cartItem.id, // Asumiendo que CartItem tiene un ID
          name: cartItem.name,
          price: itemPrice, // <-- CORREGIDO: ahora es double
          quantity: cartItem.quantity,
          addons: cartItem.addons,
        );
      }).toList();

      // 2. Crear el Objeto OrderModel
      final newOrder = OrderModel(
        userId: user.uid,
        totalAmount: widget.total,
        status: 'Pendiente', // Estado inicial
        paymentMethod: selectedPaymentMethod,
        deliveryAddress: deliveryAddress, // Usar la dirección seleccionada
        orderDate: Timestamp.now(),
        items: orderItems,
      );

      // 3. Subir el pedido a Firestore y obtener el ID
      final orderId = await _orderService.placeOrder(newOrder);

      if (!mounted) return;

      // 4. Limpiar el carrito y actualizar UI
      final cartManager = Provider.of<CartManager>(context, listen: false);
      cartManager.clearCart();

      setState(() {
        isProcessing = false;
      });

      // 5. Mostrar diálogo de éxito y navegación
      _showSuccessDialog(orderId);
      
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isProcessing = false;
      });
      _showErrorDialog('Error al procesar el pedido', 'No se pudo completar la transacción. Intenta de nuevo. Detalles: $e');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
  
  void _showSuccessDialog(String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 60),
            ),
            const SizedBox(height: 16),
            const Text(
              '¡Pago Exitoso!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tu pedido ha sido confirmado',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${orderId.substring(0, 8)}...',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navegar: 1. Cerrar diálogo, 2. Cerrar Checkout, 3. Abrir Tracking
                Navigator.of(context).pop();
                Navigator.of(context).pop(); 
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderTrackingPage(orderId: orderId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Rastrear mi Pedido',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}