import 'package:flutter/material.dart';

// --- PALETA DE COLORES (Consistente en toda la app) ---
final Color primaryColor = const Color(0xFF8B4513); // Marrón Café Tostado
final Color accentColor = const Color(0xFFD2B48C); // Beige/Ocre
final Color darkTextColor = const Color(0xFF5C4033); // Marrón Oscuro
final Color lightBackgroundColor = const Color(0xFFFAF0E6); // Crema Suave

// --- 1. MODELOS DE DATOS UNIFICADOS Y ENRIQUECIDOS ---

// Modelo para los complementos o adiciones
class AddOn {
  final String name;
  final double price;
  final String icon; // Para usar iconos en la UI
  final String description;

  AddOn({
    required this.name,
    required this.price,
    required this.icon,
    required this.description,
  });
}

// Modelo de producto principal (funciona para el menú y los más vendidos)
class Product {
  final String id;
  final String category;
  final String name;
  final String description;
  final String imageUrl;
  final double basePrice;
  // Mapa de tamaños: Nombre (key) -> Multiplicador de precio (value)
  final Map<String, double> sizeMultipliers;
  final List<AddOn> availableAddons;

  Product({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.basePrice,
    required this.sizeMultipliers,
    required this.availableAddons,
  });

  // Constructor para crear un producto configurado para el carrito (mock)
  Product.configured({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.basePrice,
    required this.sizeMultipliers,
    required this.availableAddons,
    required this.selectedSize,
    required this.selectedAddons,
    required this.finalPrice,
  });

  String? selectedSize;
  List<AddOn>? selectedAddons;
  double? finalPrice;
}

// --- DATOS DE EJEMPLO ENRIQUECIDOS ---

// Definición de AddOns comunes y promocionales
final List<AddOn> globalAddOns = [
  AddOn(name: 'Azúcar Extra', price: 0.00, icon: 'cubes', description: 'Porción adicional de azúcar.'),
  AddOn(name: 'Crema Batida', price: 0.50, icon: 'cream', description: 'Un toque de dulzura y textura.'),
  AddOn(name: 'Extra Shot Espresso', price: 1.00, icon: 'coffee', description: 'Doble dosis de energía.'),
  // Complemento en descuento para hacerlo llamativo
  AddOn(name: 'Rebana Pastel (-20%)', price: 3.20, icon: 'cake', description: 'Pastel del día a precio especial.'),
];

final List<Product> allProducts = [
  // Cafés Calientes
  Product(
    id: 'c1',
    category: 'Calientes',
    name: 'Espresso Clásico',
    description: 'Shot concentrado de café arábica con notas a cacao.',
    basePrice: 2.00,
    imageUrl: 'https://placehold.co/600x400/5C4033/FFF?text=Espresso',
    sizeMultipliers: {'Pequeño': 1.0, 'Doble': 1.5},
    availableAddons: globalAddOns.sublist(0, 3), // Sin pastel en espresso
  ),
  Product(
    id: 'c2',
    category: 'Calientes',
    name: 'Latte Vainilla',
    description: 'Suave espresso, leche vaporizada y jarabe de vainilla.',
    basePrice: 3.50,
    imageUrl: 'https://placehold.co/600x400/D2B48C/5C4033?text=Latte',
    sizeMultipliers: {'Pequeño': 1.0, 'Mediano': 1.2, 'Grande': 1.5},
    availableAddons: globalAddOns,
  ),
  Product(
    id: 'c3',
    category: 'Calientes',
    name: 'Cappuccino Canela',
    description: 'Partes iguales de espresso, leche y espuma, espolvoreado con canela.',
    basePrice: 3.75,
    imageUrl: 'https://placehold.co/600x400/A0522D/FFF?text=Cappuccino',
    sizeMultipliers: {'Mediano': 1.0, 'Grande': 1.3},
    availableAddons: globalAddOns,
  ),

  // Cafés Fríos
  Product(
    id: 'f1',
    category: 'Fríos',
    name: 'Iced Latte',
    description: 'Latte helado refrescante, perfecto para el calor.',
    basePrice: 4.00,
    imageUrl: 'https://placehold.co/600x400/87CEEB/FFF?text=Iced+Latte',
    sizeMultipliers: {'Pequeño': 1.0, 'Mediano': 1.2, 'Grande': 1.5},
    availableAddons: globalAddOns,
  ),
  Product(
    id: 'f2',
    category: 'Fríos',
    name: 'Frappé Mocha',
    description: 'Bebida helada de café, chocolate y abundante crema batida.',
    basePrice: 4.75,
    imageUrl: 'https://placehold.co/600x400/4B3621/FFF?text=Frappe',
    sizeMultipliers: {'Mediano': 1.0, 'Jumbo': 1.4},
    availableAddons: globalAddOns,
  ),
  
  // Postres
  Product(
    id: 'p1',
    category: 'Postres',
    name: 'Brownie Fudge',
    description: 'El clásico postre de chocolate, denso y húmedo, con nueces.',
    basePrice: 3.00,
    imageUrl: 'https://placehold.co/600x400/5C4033/D2B48C?text=Brownie',
    // Los postres solo tienen un tamaño base
    sizeMultipliers: {'Porción Estándar': 1.0},
    availableAddons: globalAddOns.sublist(1, 3), // Crema Batida y Shot
  ),
  Product(
    id: 'p2',
    category: 'Postres',
    name: 'Tarta de Queso',
    description: 'Cheesecake cremoso con base de galleta y salsa de frutos rojos.',
    basePrice: 4.50,
    imageUrl: 'https://placehold.co/600x400/FAF0E6/8B4513?text=Cheesecake',
    sizeMultipliers: {'Porción Estándar': 1.0},
    availableAddons: globalAddOns.sublist(1, 4), // Crema, Shot, Pastel
  ),
];

// Datos de 'Más Vendidos' para la HomePage (Referenciados desde allProducts)
final List<Product> bestSellers = [
  allProducts.firstWhere((p) => p.name == 'Latte Vainilla'),
  allProducts.firstWhere((p) => p.name == 'Brownie Fudge'),
  allProducts.firstWhere((p) => p.name == 'Espresso Clásico'),
];

// --- APP PRINCIPAL Y RUTAS ---

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Café Aroma App',
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: accentColor,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/': (context) => const HomePage(),
        '/home': (context) => const HomePage(),
        '/menu': (context) => const MenuPage(),
        '/detail': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Product;
          return ProductDetailPage(product: product);
        },
        '/orders': (context) => const PlaceholderScreen(title: 'Pedidos / Carrito'),
        '/profile': (context) => const PlaceholderScreen(title: 'Perfil'),
      },
    );
  }
}

// --- 2. WIDGET DE DETALLE DEL PRODUCTO (ProductDetailPage) ---

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Estado
  late String _selectedSize;
  final Set<AddOn> _selectedAddOns = {};
  late double _currentPrice;

  // Colores locales
  final Color primaryColor = const Color(0xFF8B4513);
  final Color darkTextColor = const Color(0xFF5C4033);

  @override
  void initState() {
    super.initState();
    // Inicializar con el primer tamaño disponible
    _selectedSize = widget.product.sizeMultipliers.keys.first;
    _calculatePrice();
  }

  void _calculatePrice() {
    double price = widget.product.basePrice;
    
    // 1. Aplicar multiplicador de tamaño
    final multiplier = widget.product.sizeMultipliers[_selectedSize] ?? 1.0;
    price *= multiplier;

    // 2. Sumar precio de complementos
    for (var addon in _selectedAddOns) {
      price += addon.price;
    }

    setState(() {
      _currentPrice = price;
    });
  }

  void _toggleAddOn(AddOn addon) {
    setState(() {
      if (_selectedAddOns.contains(addon)) {
        _selectedAddOns.remove(addon);
      } else {
        _selectedAddOns.add(addon);
      }
      _calculatePrice();
    });
  }

  // Simular agregar al carrito
  void _addToCart() {
    final configuredProduct = Product.configured(
      id: widget.product.id,
      category: widget.product.category,
      name: widget.product.name,
      description: widget.product.description,
      imageUrl: widget.product.imageUrl,
      basePrice: widget.product.basePrice,
      sizeMultipliers: widget.product.sizeMultipliers,
      availableAddons: widget.product.availableAddons,
      selectedSize: _selectedSize,
      selectedAddons: _selectedAddOns.toList(),
      finalPrice: _currentPrice,
    );

    // Mensaje de confirmación llamativo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡${configuredProduct.name} añadido! Tamaño: ${_selectedSize}. Total: \$${_currentPrice.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor.withOpacity(0.9),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- Componente para Selección de Tamaño ---
  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona tu Tamaño',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkTextColor),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: widget.product.sizeMultipliers.keys.map((size) {
            final isSelected = _selectedSize == size;
            final sizeMultiplier = widget.product.sizeMultipliers[size] ?? 1.0;
            final priceIncrease = (sizeMultiplier - 1.0) * widget.product.basePrice;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSize = size;
                  _calculatePrice();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : lightBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? primaryColor : primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      size,
                      style: TextStyle(
                        color: isSelected ? Colors.white : darkTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (priceIncrease > 0)
                      Text(
                        '+ \$${priceIncrease.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- Componente para Selección de Complementos ---
  Widget _buildAddOnsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complementa tu Pedido',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkTextColor),
        ),
        const SizedBox(height: 12),
        ...widget.product.availableAddons.map((addon) {
          final isSelected = _selectedAddOns.contains(addon);
          final isDiscounted = addon.name.contains('Pastel'); // Destacar promoción
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () => _toggleAddOn(addon),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? accentColor.withOpacity(0.5)
                      : lightBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDiscounted ? Colors.redAccent : (isSelected ? primaryColor : Colors.transparent),
                    width: isDiscounted ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getIconForAddOn(addon.icon),
                      color: darkTextColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                addon.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkTextColor,
                                ),
                              ),
                              if (isDiscounted)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '¡OFERTA!',
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            addon.description,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      addon.price == 0.00
                          ? 'GRATIS'
                          : '+\$${addon.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: addon.price == 0.00 ? Colors.green[700] : primaryColor,
                      ),
                    ),
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => _toggleAddOn(addon),
                      activeColor: primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // Mapeo simple de nombres a íconos
  IconData _getIconForAddOn(String iconName) {
    switch (iconName) {
      case 'cubes':
        return Icons.coffee_maker;
      case 'cream':
        return Icons.icecream_outlined;
      case 'coffee':
        return Icons.local_drink;
      case 'cake':
        return Icons.cake;
      default:
        return Icons.add_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // --- 1. Sliver AppBar con Imagen (Efecto llamativo) ---
              SliverAppBar(
                expandedHeight: 300.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
                  title: Text(
                    widget.product.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Imagen del producto
                      Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: primaryColor.withOpacity(0.5)),
                      ),
                      // Overlay de gradiente oscuro
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 0.5),
                            colors: <Color>[Color(0x60000000), Color(0x00000000)],
                          ),
                        ),
                      ),
                      // Overlay de gradiente inferior para legibilidad del título
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 0.0),
                            end: Alignment(0.0, 1.0),
                            colors: <Color>[Color(0x00000000), Color(0xC0000000)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- 2. Contenido del Producto ---
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Precio base
                          Text(
                            'Precio base: \$${widget.product.basePrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              color: primaryColor.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Descripción
                          Text(
                            widget.product.description,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                          const Divider(height: 30),

                          // Selector de Tamaño
                          _buildSizeSelector(),
                          const Divider(height: 40),

                          // Selector de Complementos/Add-Ons
                          _buildAddOnsSelector(),
                          const SizedBox(height: 100), // Espacio para el botón flotante
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // --- 3. Botón Flotante de Añadir al Carrito ---
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _buildFloatingCheckoutButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCheckoutButton() {
    return ElevatedButton(
      onPressed: _addToCart,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60), // Hacerlo ancho y alto
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
        shadowColor: primaryColor.withOpacity(0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Añadir al Carrito',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          Text(
            '\$${_currentPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// --- 3. PÁGINA DE INICIO (HomePage) ---

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '¡Bienvenido de nuevo!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: darkTextColor,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Tu dosis diaria de aroma y sabor te espera.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildPromoCard(context),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '☕ Más Vendidos del Mes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkTextColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildBestSellersList(context),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '🍂 Especiales de Otoño',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkTextColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSeasonalSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 0),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: lightBackgroundColor,
      elevation: 0,
      title: Text(
        'Café Aroma',
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w900,
          fontSize: 26,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined, color: darkTextColor),
          onPressed: () {
            Navigator.pushNamed(context, '/orders');
          },
        ),
      ],
    );
  }

  Widget _buildPromoCard(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡2x1 en todos los Frappés!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/menu');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                  ),
                  child: Text(
                    'Ver Oferta',
                    style: TextStyle(
                      color: darkTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellersList(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        itemCount: bestSellers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: _buildProductCard(context, bestSellers[index]),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        // Navegar a la página de detalle
        Navigator.pushNamed(context, '/detail', arguments: product);
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                product.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 100, color: accentColor.withOpacity(0.5)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: darkTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.basePrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: primaryColor,
                        ),
                      ),
                      // Botón rápido para añadir (simulado)
                      GestureDetector(
                        onTap: () {
                          // Simulación de "Añadir sin personalización"
                           ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('¡${product.name} añadido rápidamente!'),
                                backgroundColor: primaryColor,
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                        },
                        child: Container(
                           padding: const EdgeInsets.all(6),
                           decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(8),
                           ),
                           child: Icon(Icons.add, color: darkTextColor, size: 20),
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
    );
  }

  Widget _buildSeasonalSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: lightBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pumpkin Spice Latte',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'El sabor inconfundible de la calabaza y las especias. ¡Tiempo limitado!',
                  style: TextStyle(
                    fontSize: 14,
                    color: darkTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                '🎃', // Emoji de calabaza
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      showUnselectedLabels: false,
      onTap: (index) {
        String routeName;
        switch (index) {
          case 0: routeName = '/home'; break;
          case 1: routeName = '/menu'; break;
          case 2: routeName = '/orders'; break;
          case 3: routeName = '/orders'; break; // Podría ser una vista de historial si 'orders' es carrito
          case 4: routeName = '/profile'; break;
          default: return;
        }
        if (ModalRoute.of(context)?.settings.name != routeName) {
           Navigator.pushReplacementNamed(context, routeName);
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.coffee_outlined), activeIcon: Icon(Icons.coffee), label: 'Menú'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Carrito'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Pedidos'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}

// --- 4. PÁGINA DE MENÚ (MenuPage) ---

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFF8B4513);
  final Color darkTextColor = const Color(0xFF5C4033);
  final Color accentColor = const Color(0xFFD2B48C);

  // Obtiene las categorías únicas de la lista de productos
  late final List<String> categories = allProducts.map((e) => e.category).toSet().toList();
  
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
            _buildSliverAppBar(),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: categories.map((category) {
            final categoryItems = allProducts.where((item) => item.category == category).toList();
            return _buildCategoryList(context, categoryItems);
          }).toList(),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 1),
    );
  }
  
  // --- Componentes ---
  
  Widget _buildSliverAppBar() {
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
      elevation: 4,
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: darkTextColor),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Búsqueda simulada...')),
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

  Widget _buildCategoryList(BuildContext context, List<Product> items) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 2, color: Color(0xFFF5F5F5), indent: 100),
      itemBuilder: (context, index) {
        return _buildMenuItemTile(context, items[index]);
      },
    );
  }

  Widget _buildMenuItemTile(BuildContext context, Product item) {
    return InkWell(
      onTap: () {
        // Navegar a la página de detalle
        Navigator.pushNamed(context, '/detail', arguments: item);
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
            
            // Nombre y Descripción
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
            
            // Precio y Botón de Añadir
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${item.basePrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                // Botón rápido para añadir (simulado)
                GestureDetector(
                  onTap: () {
                    // Simulación de "Añadir sin personalización"
                     ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('¡${item.name} añadido rápidamente!'),
                          backgroundColor: primaryColor,
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add, color: darkTextColor, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      showUnselectedLabels: false,
      onTap: (index) {
        String routeName;
        switch (index) {
          case 0: routeName = '/home'; break;
          case 1: routeName = '/menu'; break;
          case 2: routeName = '/orders'; break;
          case 3: routeName = '/orders'; break;
          case 4: routeName = '/profile'; break;
          default: return;
        }
        if (ModalRoute.of(context)?.settings.name != routeName) {
           Navigator.pushReplacementNamed(context, routeName);
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.coffee_outlined), activeIcon: Icon(Icons.coffee), label: 'Menú'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Carrito'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Pedidos'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}

// --- 5. PANTALLA DE RELLENO (Simulación de otras rutas) ---

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final int currentIndex = title.contains('Perfil') ? 4 : (title.contains('Carrito') ? 2 : 3);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold)),
        backgroundColor: lightBackgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: primaryColor.withOpacity(0.5)),
            const SizedBox(height: 20),
            Text('Vista de $title en construcción...', style: TextStyle(fontSize: 18, color: darkTextColor)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, currentIndex),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      showUnselectedLabels: false,
      onTap: (index) {
        String routeName;
        switch (index) {
          case 0: routeName = '/home'; break;
          case 1: routeName = '/menu'; break;
          case 2: routeName = '/orders'; break;
          case 3: routeName = '/orders'; break;
          case 4: routeName = '/profile'; break;
          default: return;
        }
         if (ModalRoute.of(context)?.settings.name != routeName) {
           Navigator.pushReplacementNamed(context, routeName);
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.coffee_outlined), activeIcon: Icon(Icons.coffee), label: 'Menú'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Carrito'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Pedidos'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outlined), activeIcon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}