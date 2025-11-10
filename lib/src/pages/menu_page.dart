import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/src/data/cart_manager.dart';

// Constante para el costo de adicionales (debe ser la misma que en main.dart)
const double addonCost = 0.50;

// Definición del modelo de producto para el menú
class MenuItem {
  final String id;
  final String category;
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final List<String> availableAddons;

  MenuItem({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.availableAddons = const [],
  });
}

// Datos de ejemplo
final List<MenuItem> menuItems = [
  // Cafés Calientes
  MenuItem(id: 'c1', category: 'Calientes', name: 'Espresso Clásico', description: 'Shot concentrado de café arábica.', price: '\$2.00', imageUrl: 'https://placehold.co/600x400/5C4033/FFF?text=Espresso', availableAddons: ['Extra Shot', 'Azúcar Moreno']),
  MenuItem(id: 'c2', category: 'Calientes', name: 'Latte Vainilla', description: 'Suave espresso, leche vaporizada y jarabe de vainilla.', price: '\$3.50', imageUrl: 'https://placehold.co/600x400/D2B48C/5C4033?text=Latte', availableAddons: ['Leche de Almendras', 'Extra Shot', 'Crema']),
  MenuItem(id: 'c3', category: 'Calientes', name: 'Cappuccino Canela', description: 'Partes iguales de espresso, leche y espuma, con canela.', price: '\$3.75', imageUrl: 'https://placehold.co/600x400/A0522D/FFF?text=Cappuccino'),

  // Cafés Fríos
  MenuItem(id: 'f1', category: 'Fríos', name: 'Iced Latte', description: 'Latte helado refrescante.', price: '\$4.00', imageUrl: 'https://placehold.co/600x400/87CEEB/FFF?text=Iced+Latte', availableAddons: ['Shot de Caramelo', 'Doble Hielo']),
  MenuItem(id: 'f2', category: 'Fríos', name: 'Frappé Mocha', description: 'Bebida helada de café, chocolate y crema batida.', price: '\$4.75', imageUrl: 'https://placehold.co/600x400/4B3621/FFF?text=Frappe', availableAddons: ['Salsa Extra', 'Leche Deslactosada']),
  MenuItem(id: 'f3', category: 'Fríos', name: 'Cold Brew', description: 'Extracción lenta y concentrada de café frío.', price: '\$3.25', imageUrl: 'https://placehold.co/600x400/303030/FFF?text=Cold+Brew', availableAddons: ['Shot de Vainilla']),

  // Postres
  MenuItem(id: 'p1', category: 'Postres', name: 'Brownie Fudge', description: 'El clásico postre de chocolate, denso y húmedo.', price: '\$3.00', imageUrl: 'https://placehold.co/600x400/5C4033/D2B48C?text=Brownie'),
  MenuItem(id: 'p2', category: 'Postres', name: 'Tarta de Queso', description: 'Cheesecake cremoso con base de galleta.', price: '\$4.50', imageUrl: 'https://placehold.co/600x400/FAF0E6/8B4513?text=Cheesecake', availableAddons: ['Salsa de Frutos Rojos', 'Doble Porción']),
];

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF8B4513);
  final Color accentColor = const Color(0xFFD2B48C);
  final Color darkTextColor = const Color(0xFF5C4033);

  late final List<String> categories = menuItems.map((e) => e.category).toSet().toList();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _buildSliverAppBar(innerBoxIsScrolled),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: categories.map((category) {
            final categoryItems = menuItems.where((item) => item.category == category).toList();
            return _buildCategoryList(context, categoryItems);
          }).toList(),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      title: Text(
        'Menú Aroma',
        style: TextStyle(
          color: darkTextColor,
          fontWeight: FontWeight.w900,
          fontSize: 26,
        ),
      ),
      pinned: true,
      floating: true,
      snap: true,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: darkTextColor),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Abriendo barra de búsqueda...')),
            );
          },
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey[400],
        indicatorColor: primaryColor,
        indicatorWeight: 4.0,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: categories.map((category) => Tab(text: category)).toList(),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<MenuItem> items) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 2, color: Color(0xFFF5F5F5), indent: 100),
      itemBuilder: (context, index) {
        return _buildMenuItemTile(context, items[index]);
      },
    );
  }

  Widget _buildMenuItemTile(BuildContext context, MenuItem item) {
    return InkWell(
      onTap: () {
        _showProductDetailModal(context, item);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Icon(Icons.coffee, color: darkTextColor)),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.price,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add, color: darkTextColor, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetailModal(BuildContext context, MenuItem product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        int quantity = 1;
        List<String> selectedAddons = [];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final priceBase = double.tryParse(product.price.replaceAll('\$', '')) ?? 0.0;
            final addonCount = selectedAddons.length;
            final currentItemPrice = (priceBase + (addonCount * addonCost)) * quantity;

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: darkTextColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.description,
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Precio Base: ${product.price}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (product.availableAddons.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adicionales (\$${addonCost.toStringAsFixed(2)} c/u):',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          children: product.availableAddons.map((addon) {
                            final isSelected = selectedAddons.contains(addon);
                            return FilterChip(
                              label: Text(addon),
                              selected: isSelected,
                              backgroundColor: Colors.grey[100],
                              selectedColor: accentColor,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    selectedAddons.add(addon);
                                  } else {
                                    selectedAddons.remove(addon);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cantidad:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Color(0xFF5C4033)),
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) quantity--;
                                });
                              },
                            ),
                            Text(
                              '$quantity',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Color(0xFF5C4033)),
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Accedemos al CartManager usando Provider
                        final cartManager = Provider.of<CartManager>(context, listen: false);
                        cartManager.addItem(
                          product.id,
                          product.name,
                          product.price,
                          selectedAddons,
                          quantity,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$quantity x ${product.name} (+\$${(addonCount * addonCost).toStringAsFixed(2)} en extras) añadido al carrito.',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Añadir al Carrito - \$${currentItemPrice.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    const int currentIndex = 1;

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