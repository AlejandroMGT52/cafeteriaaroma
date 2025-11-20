// lib/src/data/services/order_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final CollectionReference _ordersCollection = 
      FirebaseFirestore.instance.collection('orders');

  // **********************************
  // 1. CREATE (Crear un nuevo pedido)
  // **********************************
  Future<String> placeOrder(OrderModel order) async {
    try {
      // Usamos order.toFirestore() para guardar los datos
      DocumentReference docRef = await _ordersCollection.add(order.toFirestore());
      return docRef.id; // Retorna el ID del pedido
    } catch (e) {
      print("Error al crear el pedido: $e");
      rethrow;
    }
  }

  // **********************************
  // 2. READ (Obtener pedidos de un usuario - Stream)
  // **********************************
  Stream<List<OrderModel>> getOrdersStreamForUser(String userId) {
    // Consulta los pedidos donde el campo 'userId' coincide con el UID del usuario
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true) // Pedidos más recientes primero
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    });
  }

  // **********************************
  // 3. READ (Obtener detalles de un pedido específico - Stream)
  // **********************************
  Stream<OrderModel> getOrderStreamById(String orderId) {
    return _ordersCollection.doc(orderId).snapshots().map((doc) {
      return OrderModel.fromFirestore(doc);
    });
  }

  // **********************************
  // 4. UPDATE (Actualizar el estado de un pedido o detalles)
  // **********************************
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _ordersCollection.doc(orderId).update({'status': newStatus});
    } catch (e) {
      print("Error al actualizar el estado del pedido: $e");
      rethrow;
    }
  }

  // **********************************
  // 5. DELETE (Cancelar un pedido)
  // **********************************
  Future<void> cancelOrder(String orderId) async {
    // En lugar de eliminar, es mejor actualizar el estado a 'Cancelled'
    return updateOrderStatus(orderId, 'Cancelled');
  }
}