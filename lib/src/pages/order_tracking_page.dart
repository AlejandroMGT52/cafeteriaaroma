// lib/src/pages/order_tracking_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/order_service.dart';
import '../data/models/order_model.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId;

  const OrderTrackingPage({super.key, required this.orderId});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> 
    with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF8B4513);
  final Color accentColor = const Color(0xFFD2B48C);
  final Color darkTextColor = const Color(0xFF5C4033);
  
  final OrderService _orderService = OrderService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late AnimationController _animationController;
  late Animation<double> _bikeAnimation;
  
  bool _hasShownDeliveryDialog = false;

  final List<String> statusOrder = [
    'Pendiente', 
    'Preparando', 
    'En Camino', 
    'Entregado', 
    'Cancelado'
  ];
  
  final List<Map<String, dynamic>> orderStepsTemplate = [
    {'title': 'Pedido Recibido', 'icon': Icons.check_circle},
    {'title': 'Preparando', 'icon': Icons.restaurant},
    {'title': 'En Camino', 'icon': Icons.delivery_dining},
    {'title': 'Entregado', 'icon': Icons.home},
  ];

  @override
  void initState() {
    super.initState();
    
    // Animación de la moto (movimiento horizontal)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _bikeAnimation = Tween<double>(
      begin: -30.0, 
      end: 30.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _showDeliveryCompleteDialog() {
    if (!mounted || _hasShownDeliveryDialog) return;
    
    _hasShownDeliveryDialog = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.celebration, 
                color: Colors.green, 
                size: 60,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '¡Pedido Entregado!',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¡Disfruta tu café!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '⭐⭐⭐⭐⭐',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              '¿Qué te pareció tu experiencia?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text('Más tarde'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Gracias por tu calificación!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text('Calificar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderModel>(
      stream: _orderService.getOrderStreamById(widget.orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 20),
                  Text(
                    'Cargando pedido...',
                    style: TextStyle(color: darkTextColor),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                      'Error al cargar la orden',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final order = snapshot.data;
        if (order == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Pedido no encontrado')),
            body: const Center(
              child: Text('El ID de pedido no es válido o la orden fue eliminada.'),
            ),
          );
        }

        // Mostrar diálogo de entrega completada
        if (order.status == 'Entregado' && !_hasShownDeliveryDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ModalRoute.of(context)?.isCurrent ?? false) {
              _showDeliveryCompleteDialog();
            }
          });
        }
        
        final currentStepIndex = statusOrder.indexOf(order.status);
        final displayStep = (currentStepIndex >= 0 && currentStepIndex <= 3) 
            ? currentStepIndex 
            : 0;
        final isDeliveryActive = order.status == 'En Camino';

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(
              'Seguimiento de Pedido',
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
            child: Column(
              children: [
                // 🏍️ Animación del mapa con moto
                _buildMapWithBikeAnimation(order.status),

                // Panel de información
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ID del Pedido
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20, 
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt, color: primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Pedido #${order.id!.substring(0, 8)}...',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: darkTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Estado principal
                      _buildMainStatus(order.status, displayStep),
                      const SizedBox(height: 24),

                      // Timeline de pasos
                      _buildTimeline(displayStep, order.status),
                      const SizedBox(height: 24),

                      // Información del repartidor
                      if (isDeliveryActive) _buildDeliveryInfo(),

                      const SizedBox(height: 16),

                      // Botones de acción
                      if (order.status != 'Entregado' && 
                          order.status != 'Cancelado') ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showContactOptions(),
                            icon: const Icon(Icons.phone),
                            label: const Text('Contactar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _showCancelOrderDialog(order.id!),
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text('Cancelar Pedido'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🏍️ NUEVO: Mapa con animación de moto mejorada
  Widget _buildMapWithBikeAnimation(String status) {
    bool isDeliveryActive = status == 'En Camino';
    bool isPreparingOrPending = status == 'Pendiente' || status == 'Preparando';
    
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accentColor.withOpacity(0.3),
            Colors.white,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Líneas de fondo (estilo mapa)
          Positioned.fill(
            child: CustomPaint(
              painter: MapLinesPainter(),
            ),
          ),
          
          // 🏍️ Icono de moto animado
          if (isDeliveryActive)
            AnimatedBuilder(
              animation: _bikeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_bikeAnimation.value, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Moto
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.delivery_dining,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Línea de camino
                      Container(
                        width: 100,
                        height: 3,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          else
            // Icono estático si no está en camino
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isPreparingOrPending 
                    ? Colors.orange 
                    : primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isPreparingOrPending 
                        ? Colors.orange 
                        : primaryColor).withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(
                _getStatusIcon(status),
                size: 50,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainStatus(String status, int stepIndex) {
    String detailText;
    int estimatedTime = 0;
    
    if (status == 'Pendiente') {
      detailText = 'Esperando confirmación del restaurante';
      estimatedTime = 30;
    } else if (status == 'Preparando') {
      detailText = 'Tu café está siendo preparado';
      estimatedTime = 20;
    } else if (status == 'En Camino') {
      detailText = 'Tu repartidor está en camino';
      estimatedTime = 10;
    } else if (status == 'Entregado') {
      detailText = '¡Ya puedes disfrutar tu pedido!';
    } else if (status == 'Cancelado') {
      detailText = 'El pedido ha sido cancelado.';
    } else {
      detailText = 'Actualizando estado...';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getStatusIcon(status),
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  estimatedTime > 0 && 
                      status != 'Entregado' && 
                      status != 'Cancelado'
                      ? 'Tiempo estimado: $estimatedTime min'
                      : detailText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(int currentStepIndex, String status) {
    return Column(
      children: List.generate(orderStepsTemplate.length, (index) {
        final step = orderStepsTemplate[index];
        final isCompleted = index <= currentStepIndex;
        final isActive = index == currentStepIndex;
        final displayCompleted = status == 'Cancelado' ? index == 0 : isCompleted;

        if (status == 'Cancelado' && index > 0) {
          return const SizedBox.shrink();
        }
        
        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: displayCompleted ? primaryColor : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    step['icon'] as IconData,
                    color: displayCompleted ? Colors.white : Colors.grey[600],
                    size: 20,
                  ),
                ),
                if (index < orderStepsTemplate.length - 1 && 
                    status != 'Cancelado')
                  Container(
                    width: 2,
                    height: 40,
                    color: displayCompleted ? primaryColor : Colors.grey[300],
                  ),
                if (index == 0 && status == 'Cancelado')
                  Container(
                    width: 2,
                    height: 40,
                    color: Colors.red,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: status == 'Cancelado' ? 0 : 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isActive && status != 'Cancelado' 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                        color: displayCompleted 
                            ? darkTextColor 
                            : Colors.grey[500],
                      ),
                    ),
                    if (index == 0 && status == 'Cancelado') ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Pedido Cancelado',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.person, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carlos Rodríguez',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Repartidor • Moto',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Icon(Icons.electric_moped, color: primaryColor, size: 30),
        ],
      ),
    );
  }

  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Contactar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('Llamar al repartidor'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Llamando al repartidor...'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.blue),
              title: const Text('Enviar mensaje'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abriendo chat...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.orange),
              title: const Text('Soporte'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contactando soporte...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelOrderDialog(String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cancelar pedido?'),
        content: const Text(
          'Si cancelas ahora, se te reembolsará el monto completo. Esta acción es irreversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, mantener'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _orderService.cancelOrder(orderId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Pedido cancelado exitosamente.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Error al cancelar: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pendiente':
        return Icons.access_time;
      case 'Preparando':
        return Icons.restaurant;
      case 'En Camino':
        return Icons.delivery_dining;
      case 'Entregado':
        return Icons.check_circle;
      case 'Cancelado':
        return Icons.cancel;
      default:
        return Icons.shopping_bag;
    }
  }
}

// Painter para las líneas del mapa
class MapLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1.5;

    // Líneas horizontales
    for (var i = 0; i < 8; i++) {
      final y = size.height / 8 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Líneas verticales
    for (var i = 0; i < 8; i++) {
      final x = size.width / 8 * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}