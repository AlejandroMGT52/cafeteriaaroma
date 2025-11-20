// lib/src/data/models/order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo para los ítems dentro de un pedido
class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final List<String> addons;

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.addons,
  });

  // 1. Convertir de Map a OrderItem
  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      productId: data['productId'] as String? ?? '',
      name: data['name'] as String? ?? 'Producto Desconocido',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      quantity: data['quantity'] as int? ?? 1,
      addons: List<String>.from(data['addons'] ?? []),
    );
  }

  // 2. Convertir de OrderItem a Map (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'addons': addons,
    };
  }
}

// Modelo de Pedido Principal
class OrderModel {
  final String? id; // ID de Firestore
  final String userId;
  final double totalAmount;
  final String status; // Ej: 'Pending', 'Preparing', 'Delivering', 'Delivered', 'Cancelled'
  final String paymentMethod;
  final String deliveryAddress;
  final Timestamp orderDate;
  final List<OrderItem> items;

  OrderModel({
    this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.orderDate,
    required this.items,
  });

  // 3. Convertir de Firestore (DocumentSnapshot) a objeto OrderModel
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception("Datos de documento nulos");
    }

    // Convertir la lista de Maps de items a List<OrderItem>
    final List<OrderItem> orderItems = (data['items'] as List<dynamic>?)
        ?.map((itemMap) => OrderItem.fromMap(itemMap as Map<String, dynamic>))
        .toList() ?? [];

    return OrderModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'Pending',
      paymentMethod: data['paymentMethod'] as String? ?? 'Desconocido',
      deliveryAddress: data['deliveryAddress'] as String? ?? 'N/A',
      orderDate: data['orderDate'] as Timestamp? ?? Timestamp.now(),
      items: orderItems,
    );
  }

  // 4. Convertir de objeto OrderModel a Firestore (Map)
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress,
      'orderDate': orderDate,
      // Convertir List<OrderItem> a List<Map> para Firestore
      'items': items.map((item) => item.toMap()).toList(), 
    };
  }
}