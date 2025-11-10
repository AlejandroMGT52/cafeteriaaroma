import 'package:flutter/material.dart';

// Clase que representa un item en el carrito de compras.
class CartItem {
  final String id;  // Cambiado de int a String
  final String name;
  final String price;  // Cambiado de double a String (formato: "\$3.50")
  final int quantity;
  final List<String> addons; // Cambiado de int a List<String> para guardar los adicionales

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.addons = const [],
  });

  // Método helper para obtener el precio como double
  double get priceAsDouble {
    return double.tryParse(price.replaceAll('\$', '')) ?? 0.0;
  }

  // Calcular el precio total de este item (precio base + adicionales) * cantidad
  double get totalPrice {
    final basePrice = priceAsDouble;
    final addonCost = 0.50; // Costo por adicional
    return (basePrice + (addons.length * addonCost)) * quantity;
  }
}

// Clase para gestionar el estado del carrito de compras (Singleton simple).
// Usa ChangeNotifier para notificar a los widgets cuando el carrito cambia.
class CartManager with ChangeNotifier {
  // Patrón Singleton para acceso global
  static final CartManager _instance = CartManager._internal();

  factory CartManager() {
    return _instance;
  }

  CartManager._internal();

  // Lista de items en el carrito
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Número total de items (productos) en el carrito
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Añadir un item al carrito
  void addItem(
    String id,
    String name,
    String price,
    List<String> addons,
    int quantity,
  ) {
    _items.add(CartItem(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      addons: addons,
    ));
    notifyListeners(); // Notifica a los widgets que escuchan
  }

  // Eliminar un item del carrito
  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // Calcular el total del carrito
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Vaciar el carrito
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}