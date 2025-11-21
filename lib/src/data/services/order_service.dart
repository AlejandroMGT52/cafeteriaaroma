// lib/src/data/services/order_service.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final CollectionReference _ordersCollection = 
      FirebaseFirestore.instance.collection('orders');

  // **********************************
  // 1. CREATE (Crear un nuevo pedido con simulación de progreso)
  // **********************************
  Future<String> placeOrder(OrderModel order) async {
    try {
      // Guardar el pedido en Firestore
      DocumentReference docRef = await _ordersCollection.add(order.toFirestore());
      
      // ⚡ NUEVO: Iniciar simulación automática de progreso
      _simulateOrderProgress(docRef.id);
      
      return docRef.id; // Retorna el ID del pedido
    } catch (e) {
      print("❌ Error al crear el pedido: $e");
      rethrow;
    }
  }

  // **********************************
  // SIMULACIÓN: Progreso automático del pedido
  // **********************************
  void _simulateOrderProgress(String orderId) {
    // Estado inicial: Pendiente (ya está en la creación)
    
    // Después de 10 segundos → Preparando
    Timer(const Duration(seconds: 10), () async {
      try {
        await updateOrderStatus(orderId, 'Preparando');
        print("✅ Pedido $orderId → Preparando");
      } catch (e) {
        print("❌ Error actualizando a Preparando: $e");
      }
    });

    // Después de 30 segundos → En Camino
    Timer(const Duration(seconds: 30), () async {
      try {
        await updateOrderStatus(orderId, 'En Camino');
        print("🚴 Pedido $orderId → En Camino");
      } catch (e) {
        print("❌ Error actualizando a En Camino: $e");
      }
    });

    // Después de 60 segundos → Entregado
    Timer(const Duration(seconds: 60), () async {
      try {
        await updateOrderStatus(orderId, 'Entregado');
        print("✅ Pedido $orderId → Entregado");
      } catch (e) {
        print("❌ Error actualizando a Entregado: $e");
      }
    });
  }

  // **********************************
  // 2. READ (Obtener pedidos de un usuario - Stream)
  // **********************************
  Stream<List<OrderModel>> getOrdersStreamForUser(String userId) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
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
      if (!doc.exists) {
        throw Exception('Pedido no encontrado');
      }
      return OrderModel.fromFirestore(doc);
    });
  }

  // **********************************
  // 4. UPDATE (Actualizar el estado de un pedido)
  // **********************************
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _ordersCollection.doc(orderId).update({
        'status': newStatus,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print("✅ Estado actualizado: $orderId → $newStatus");
    } catch (e) {
      print("❌ Error al actualizar el estado del pedido: $e");
      rethrow;
    }
  }

  // **********************************
  // 5. DELETE (Cancelar un pedido)
  // **********************************
  Future<void> cancelOrder(String orderId) async {
    try {
      await _ordersCollection.doc(orderId).update({
        'status': 'Cancelado',
        'cancelledAt': FieldValue.serverTimestamp(),
      });
      print("🚫 Pedido cancelado: $orderId");
    } catch (e) {
      print("❌ Error al cancelar el pedido: $e");
      rethrow;
    }
  }

  // **********************************
  // EXTRA: Actualización manual para pruebas
  // **********************************
  Future<void> simulateNextStatus(String orderId) async {
    try {
      final doc = await _ordersCollection.doc(orderId).get();
      if (!doc.exists) return;
      
      final currentStatus = doc.data() as Map<String, dynamic>;
      final status = currentStatus['status'] as String;
      
      String nextStatus;
      switch (status) {
        case 'Pendiente':
          nextStatus = 'Preparando';
          break;
        case 'Preparando':
          nextStatus = 'En Camino';
          break;
        case 'En Camino':
          nextStatus = 'Entregado';
          break;
        default:
          return; // Ya está entregado o cancelado
      }
      
      await updateOrderStatus(orderId, nextStatus);
    } catch (e) {
      print("❌ Error en simulación manual: $e");
      rethrow;
    }
  }
}