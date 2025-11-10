import 'package:flutter/material.dart';

// --- MODELOS DE DATOS ---

class OrderItem {
  final String name;
  final String price;
  final int quantity;
  final String imageUrl;

  OrderItem({required this.name, required this.price, required this.quantity, required this.imageUrl});
}

class CoffeeOrder {
  final String id;
  final String date;
  final String total;
  final String status; // Ej: 'Preparando', 'En Camino', 'Entregado'
  final List<OrderItem> items;

  CoffeeOrder({required this.id, required this.date, required this.total, required this.status, required this.items});
}

// --- GESTIÓN DE DATOS SIMULADA ---

// Carrito / Pedidos activos (Inicialmente vacío para un "nuevo inicio de sesión")
List<CoffeeOrder> globalActiveOrders = [];

// Historial de pedidos (Se mantiene)
List<CoffeeOrder> globalHistoryOrders = [
  CoffeeOrder(
    id: '#AROMA1233',
    date: 'Ayer, 4:15 PM',
    total: '\$12.50',
    status: 'Entregado',
    items: [
      OrderItem(name: 'Frappé Mocha', price: '4.75', quantity: 2, imageUrl: 'https://placehold.co/60x60/4B3621/FFF?text=F'),
      OrderItem(name: 'Brownie Fudge', price: '3.00', quantity: 1, imageUrl: 'https://placehold.co/60x60/5C4033/D2B48C?text=B'),
    ],
  ),
  CoffeeOrder(
    id: '#AROMA1232',
    date: '02 Nov, 9:00 AM',
    total: '\$6.00',
    status: 'Entregado',
    items: [
      OrderItem(name: 'Café Filtrado', price: '2.00', quantity: 3, imageUrl: 'https://placehold.co/60x60/A0522D/FFF?text=F'),
    ],
  ),
];

// Función para simular el "inicio de sesión" y vaciar el carrito
void resetActiveOrderState() {
  // Simula que al iniciar sesión, el carrito siempre está vacío.
  globalActiveOrders.clear();
  // Puedes añadir un pedido activo de ejemplo si es necesario para testing
  // Pero lo dejaremos vacío para cumplir con tu requisito.
}

// Función para simular el envío de un pedido y ponerlo "En Camino"
void simulateNewOrder() {
  globalActiveOrders = [
    CoffeeOrder(
      id: '#AROMA1235',
      date: 'Ahora',
      total: '\$9.50',
      status: 'En Camino', // Nuevo estado para rastreo
      items: [
        OrderItem(name: 'Latte Caramelo', price: '4.00', quantity: 1, imageUrl: 'https://placehold.co/60x60/D2B48C/5C4033?text=L'),
        OrderItem(name: 'Muffin de Arándanos', price: '3.50', quantity: 1, imageUrl: 'https://placehold.co/60x60/FAF0E6/5C4033?text=M'),
      ],
    ),
  ];
}