import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/src/data/cart_manager.dart';

const double addonCost = 0.50;

class MenuItem {
  final String id;
  final String category;
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final List<String> availableAddons;
  final bool isPopular;
  final bool isNew;
  final double rating;

  MenuItem({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.availableAddons = const [],
    this.isPopular = false,
    this.isNew = false,
    this.rating = 4.5,
  });
}

final List<MenuItem> menuItems = [
  // Cafés Calientes
  MenuItem(
    id: 'c1',
    category: 'Calientes',
    name: 'Espresso Clásico',
    description: 'Shot concentrado de café arábica de origen único',
    price: '\$2.00',
    imageUrl: 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=500&h=500&fit=crop',
    availableAddons: ['Extra Shot', 'Azúcar Moreno'],
    isPopular: true,
    rating: 4.8,
  ),
  MenuItem(
    id: 'c2',
    category: 'Calientes',
    name: 'Latte Vainilla',
    description: 'Suave espresso con leche vaporizada y vainilla',
    price: '\$3.50',
    imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=500&h=500&fit=crop',
    availableAddons: ['Leche de Almendras', 'Extra Shot', 'Crema'],
    isPopular: true,
    rating: 4.7,
  ),
  MenuItem(
    id: 'c3',
    category: 'Calientes',
    name: 'Cappuccino Canela',
    description: 'Espresso, leche y espuma con canela de Ceilán',
    price: '\$3.75',
    imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=500&h=500&fit=crop',
    availableAddons: ['Extra Espuma', 'Cacao en Polvo'],
    rating: 4.6,
  ),
  MenuItem(
    id: 'c4',
    category: 'Calientes',
    name: 'Flat White',
    description: 'Espresso doble con microespuma sedosa',
    price: '\$3.80',
    imageUrl: 'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?w=500&h=500&fit=crop',
    availableAddons: ['Leche de Soja', 'Extra Shot'],
    rating: 4.9,
  ),
  MenuItem(
    id: 'c5',
    category: 'Calientes',
    name: 'Mocha Premium',
    description: 'Espresso con chocolate belga y crema',
    price: '\$4.25',
    imageUrl: 'https://images.unsplash.com/photo-1578374173705-0c7f6c78c435?w=500&h=500&fit=crop',
    availableAddons: ['Doble Chocolate', 'Crema Extra', 'Marshmallows'],
    isPopular: true,
    rating: 4.8,
  ),
  MenuItem(
    id: 'c6',
    category: 'Calientes',
    name: 'Caramel Macchiato',
    description: 'Espresso marcado con caramelo y leche',
    price: '\$4.50',
    imageUrl: 'https://images.unsplash.com/photo-1599750703576-547a5754084e?w=500&h=500&fit=crop',
    availableAddons: ['Salsa de Caramelo', 'Leche de Avena'],
    isNew: true,
    rating: 4.7,
  ),

  // Cafés Fríos
  MenuItem(
    id: 'f1',
    category: 'Fríos',
    name: 'Iced Latte',
    description: 'Latte helado refrescante con hielo premium',
    price: '\$4.00',
    imageUrl: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=500&h=500&fit=crop',
    availableAddons: ['Shot de Caramelo', 'Leche de Coco'],
    isPopular: true,
    rating: 4.6,
  ),
  MenuItem(
    id: 'f2',
    category: 'Fríos',
    name: 'Frappé Mocha',
    description: 'Bebida helada de café, chocolate y crema',
    price: '\$4.75',
    imageUrl: 'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=500&h=500&fit=crop',
    availableAddons: ['Salsa Extra', 'Chispas de Chocolate'],
    isPopular: true,
    rating: 4.8,
  ),
  MenuItem(
    id: 'f3',
    category: 'Fríos',
    name: 'Cold Brew',
    description: 'Extracción de 12 horas, suave y concentrado',
    price: '\$3.50',
    imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=500&h=500&fit=crop',
    availableAddons: ['Shot de Vainilla', 'Leche de Almendras'],
    rating: 4.7,
  ),
  MenuItem(
    id: 'f4',
    category: 'Fríos',
    name: 'Iced Americano',
    description: 'Espresso doble sobre hielo refrescante',
    price: '\$3.25',
    imageUrl: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=500&h=500&fit=crop',
    availableAddons: ['Extra Shot', 'Jarabe de Vainilla'],
    rating: 4.5,
  ),
  MenuItem(
    id: 'f5',
    category: 'Fríos',
    name: 'Frappé Caramelo',
    description: 'Deliciosa mezcla helada con caramelo',
    price: '\$4.50',
    imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=500&h=500&fit=crop',
    availableAddons: ['Salsa de Caramelo', 'Crema Extra'],
    isNew: true,
    rating: 4.6,
  ),
  MenuItem(
    id: 'f6',
    category: 'Fríos',
    name: 'Matcha Latte Frío',
    description: 'Té verde matcha japonés con leche y hielo',
    price: '\$4.25',
    imageUrl: 'https://images.unsplash.com/photo-1536013634175-67c3b7c6360b?w=500&h=500&fit=crop',
    availableAddons: ['Leche de Coco', 'Miel'],
    isNew: true,
    rating: 4.7,
  ),

  // Postres
  MenuItem(
    id: 'p1',
    category: 'Postres',
    name: 'Brownie Fudge',
    description: 'Chocolate belga, denso y húmedo',
    price: '\$3.00',
    imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500&h=500&fit=crop',
    availableAddons: ['Helado de Vainilla'],
    rating: 4.7,
  ),
  MenuItem(
    id: 'p2',
    category: 'Postres',
    name: 'Cheesecake',
    description: 'Cremoso con base de galleta graham',
    price: '\$4.50',
    imageUrl: 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=500&h=500&fit=crop',
    availableAddons: ['Salsa de Frutos Rojos'],
    isPopular: true,
    rating: 4.9,
  ),
  MenuItem(
    id: 'p3',
    category: 'Postres',
    name: 'Croissant Almendra',
    description: 'Croissant francés con crema de almendra',
    price: '\$3.50',
    imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=500&h=500&fit=crop',
    rating: 4.6,
  ),
  MenuItem(
    id: 'p4',
    category: 'Postres',
    name: 'Tiramisú',
    description: 'Clásico italiano con mascarpone y café',
    price: '\$4.75',
    imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=500&h=500&fit=crop',
    isPopular: true,
    rating: 4.8,
  ),
  MenuItem(
    id: 'p5',
    category: 'Postres',
    name: 'Muffin Arándanos',
    description: 'Esponjoso con arándanos frescos',
    price: '\$2.75',
    imageUrl: 'https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=500&h=500&fit=crop',
    rating: 4.5,
  ),

  // Especiales
  MenuItem(
    id: 'e1',
    category: 'Especiales',
    name: 'Pumpkin Spice Latte',
    description: 'Latte de temporada con calabaza y especias',
    price: '\$4.50',
    imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=500&h=500&fit=crop',
    availableAddons: ['Crema Batida', 'Canela Extra'],
    isNew: true,
    rating: 4.8,
  ),
  MenuItem(
    id: 'e2',
    category: 'Especiales',
    name: 'Chai Latte',
    description: 'Té especiado con leche vaporizada y miel',
    price: '\$4.00',
    imageUrl: 'https://images.unsplash.com/photo-1578374173705-0c7f6c78c435?w=500&h=500&fit=crop',
    availableAddons: ['Leche de Avena', 'Miel Extra'],
    rating: 4.7,
  ),
  MenuItem(
    id: 'e3',
    category: 'Especiales',
    name: 'Affogato',
    description: 'Helado de vainilla con espresso caliente',
    price: '\$4.50',
    imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&h=500&fit=crop',
    isPopular: true,
    rating: 4.9,
  ),
];
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF6F4E37);
  final Color accentColor = const Color(0xFFD4A574);
  final Color darkTextColor = const Color(0xFF4A3728);

  late final List<String> categories = menuItems.map((e) => e.category).toSet().toList();
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _buildSliverAppBar(),
          ];
        },
        body: Column(
          children: [
            _buildSearchBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: categories.map((category) {
                  final categoryItems = menuItems
                      .where((item) =>
                          item.category == category &&
                          (_searchQuery.isEmpty ||
                              item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                              item.description.toLowerCase().contains(_searchQuery.toLowerCase())))
                      .toList();
                  return _buildCategoryGrid(context, categoryItems);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, accentColor],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nuestro Menú',
                style: TextStyle(
                  color: darkTextColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
              Text(
                '${menuItems.length} productos',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Consumer<CartManager>(
          builder: (context, cartManager, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8DC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, 'orders'),
                ),
                if (cartManager.itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.redAccent],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartManager.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar café, postre, bebida...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          prefixIcon: Icon(Icons.search, color: primaryColor, size: 26),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 22),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey[400],
        indicatorColor: primaryColor,
        indicatorWeight: 3.5,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 15),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tabs: categories.map((category) {
          String emoji = '☕';
          if (category == 'Fríos') emoji = '🧊';
          if (category == 'Postres') emoji = '🍰';
          if (category == 'Especiales') emoji = '⭐';
          
          final count = menuItems.where((item) => item.category == category).length;
          
          return Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Text(category),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  Widget _buildCategoryGrid(BuildContext context, List<MenuItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              'No encontramos productos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta con otra búsqueda',
              style: TextStyle(fontSize: 15, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildMenuCard(context, items[index]);
      },
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showProductDetailModal(context, item),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del producto
                Hero(
                  tag: 'menu_${item.id}',
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            item.imageUrl,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: accentColor.withOpacity(0.2),
                                child: Icon(Icons.coffee, color: primaryColor, size: 40),
                              );
                            },
                          ),
                        ),
                        // Badge Popular/Nuevo
                        if (item.isPopular || item.isNew)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: item.isPopular
                                      ? [Colors.orange.shade400, Colors.deepOrange]
                                      : [Colors.green.shade400, Colors.teal],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: (item.isPopular ? Colors.orange : Colors.green).withOpacity(0.4),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    item.isPopular ? Icons.local_fire_department : Icons.fiber_new,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    item.isPopular ? 'HOT' : 'NEW',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Información del producto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre y rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: darkTextColor,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: Colors.orange.shade600,
                                  size: 16,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${item.rating}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Descripción
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      // Precio y botón
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.price,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: primaryColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor, accentColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _showProductDetailModal(context, item),
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Agregar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Adicionales disponibles
                      if (item.availableAddons.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: accentColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: primaryColor,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Personalizable',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showProductDetailModal(BuildContext context, MenuItem product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) {
      int quantity = 1;
      List<String> selectedAddons = [];

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          final priceBase = double.tryParse(product.price.replaceAll('\$', '')) ?? 0.0;
          final addonCount = selectedAddons.length;
          final currentItemPrice = (priceBase + (addonCount * addonCost)) * quantity;

            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  // Barra superior
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Imagen
                  Stack(
                    children: [
                      Hero(
                        tag: 'menu_${product.id}',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                          child: Image.network(
                            product.imageUrl,
                            height: 280,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.close, size: 24),
                          ),
                        ),
                      ),
                      if (product.isPopular || product.isNew)
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: product.isPopular
                                    ? [Colors.orange, Colors.deepOrange]
                                    : [Colors.green, Colors.lightGreen],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  product.isPopular ? Icons.star : Icons.fiber_new,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  product.isPopular ? 'Popular' : 'Nuevo',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Contenido
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: darkTextColor,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.orange, size: 20),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${product.rating}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(Icons.attach_money, color: primaryColor, size: 28),
                              const SizedBox(width: 4),
                              Text(
                                'Precio base: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                product.price,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          if (product.availableAddons.isNotEmpty) ...[
                            const SizedBox(height: 28),
                            const Divider(thickness: 1),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(Icons.add_circle_outline, color: primaryColor, size: 26),
                                const SizedBox(width: 10),
                                Text(
                                  'Personaliza tu bebida',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: darkTextColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Adicionales +\${addonCost.toStringAsFixed(2)} c/u',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              spacing: 12.0,
                              runSpacing: 12.0,
                              children: product.availableAddons.map((addon) {
                                final isSelected = selectedAddons.contains(addon);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedAddons.remove(addon);
                                      } else {
                                        selectedAddons.add(addon);
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? LinearGradient(
                                              colors: [primaryColor, accentColor],
                                            )
                                          : null,
                                      color: isSelected ? null : Colors.white,
                                      border: Border.all(
                                        color: isSelected ? Colors.transparent : Colors.grey[300]!,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: primaryColor.withOpacity(0.3),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isSelected ? Icons.check_circle : Icons.add_circle_outline,
                                          color: isSelected ? Colors.white : primaryColor,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          addon,
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : darkTextColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                          const SizedBox(height: 28),
                          const Divider(thickness: 1),
                          const SizedBox(height: 20),
                          // Sección de cantidad y precio
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Cantidad
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.shopping_basket_outlined, color: primaryColor, size: 22),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Cantidad',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: darkTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: quantity > 1 ? primaryColor : Colors.grey[300],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                color: quantity > 1 ? Colors.white : Colors.grey[500],
                                                size: 18,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (quantity > 1) quantity--;
                                              });
                                            },
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Text(
                                              '$quantity',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: darkTextColor,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [primaryColor, accentColor],
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
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
                              ),
                              const SizedBox(width: 24),
                              // Resumen de precio
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.receipt_long_outlined, color: primaryColor, size: 22),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: darkTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [primaryColor.withOpacity(0.1), accentColor.withOpacity(0.15)],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (selectedAddons.isNotEmpty) ...[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Base:',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                Text(
                                                  '\${(priceBase * quantity).toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Extras (${addonCount}):',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                Text(
                                                  '+\${(addonCount * addonCost * quantity).toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(height: 16, thickness: 1),
                                          ],
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Total:',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: darkTextColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '\${currentItemPrice.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                  color: primaryColor,
                                                  height: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  // Botón de agregar
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
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
                                content: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            '¡Agregado al carrito!',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '$quantity x ${product.name}',
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 4,
                            shadowColor: primaryColor.withOpacity(0.4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                              SizedBox(width: 12),
                              Text(
                                'Agregar al carrito',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        showUnselectedLabels: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        onTap: (index) {
          String routeName;
          switch (index) {
            case 0:
              routeName = 'home';
              break;
            case 1:
              return;
            case 2:
              routeName = 'orders';
              break;
            case 3:
              routeName = 'profile';
              break;
            default:
              return;
          }
          Navigator.pushReplacementNamed(context, routeName);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 26),
            activeIcon: Icon(Icons.home, size: 26),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined, size: 26),
            activeIcon: Icon(Icons.restaurant_menu, size: 26),
            label: 'Menú',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined, size: 26),
            activeIcon: Icon(Icons.shopping_bag, size: 26),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 26),
            activeIcon: Icon(Icons.person, size: 26),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}