import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/src/data/cart_manager.dart';
import 'dart:async';

// Modelo de Producto
class Product {
  final String id;
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final String? badge;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.badge,
    this.rating = 4.5,
  });
}

// DATOS: Carrusel (Imágenes actualizadas)
final List<Product> carouselProducts = [
  Product(
    id: 'promo1',
    name: 'Caramel Macchiato',
    description: 'Espresso con caramelo y leche vaporizada',
    price: '\$4.50',
    // CAMBIAR URL AQUI: Puedes poner tu propia URL dentro de las comillas
    imageUrl: 'https://huupa.coffee/cdn/shop/articles/caramel_macchiato.jpg?v=1742928081',
    badge: '2x1 HOY',
    rating: 4.8,
  ),
  Product(
    id: 'promo2',
    name: 'Iced Americano',
    description: 'Espresso doble con hielo refrescante',
    price: '\$3.75',
    imageUrl: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=800&h=500&fit=crop',
    badge: 'NUEVO',
    rating: 4.7,
  ),
  Product(
    id: 'promo3',
    name: 'Cappuccino Premium',
    description: 'Arte latte con espuma perfecta',
    price: '\$4.00',
    imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=800&h=500&fit=crop',
    badge: 'POPULAR',
    rating: 4.9,
  ),
];

// DATOS: Más Vendidos (Imágenes actualizadas y corregidas)
final List<Product> bestSellers = [
  Product(
    id: '1',
    name: 'Espresso',
    description: 'Intenso y aromático',
    price: '\$2.50',
    // CAMBIAR URL AQUI
    imageUrl: 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=600&h=400&fit=crop',
    rating: 4.6,
  ),
  Product(
    id: '2',
    name: 'Flat White',
    description: 'Microespuma sedosa',
    price: '\$3.80',
    imageUrl: 'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?w=600&h=400&fit=crop',
    rating: 4.8,
  ),
  Product(
    id: '3',
    name: 'Cold Brew',
    description: 'Extracción en frío',
    price: '\$3.50',
    imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=600&h=400&fit=crop',
    rating: 4.7,
  ),
  Product(
    id: '4',
    name: 'Mocha',
    description: 'Chocolate y espresso',
    price: '\$4.25',
    imageUrl: 'https://dfrnt.coffee/cdn/shop/articles/como-preparar-un-cafe-moca-profesional-en-casa-537303.png?v=1733918360',
    rating: 4.9,
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Ajustamos viewportFraction para que se vea un poco de la siguiente tarjeta
    _pageController = PageController(viewportFraction: 0.9);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < carouselProducts.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Fondo un poco más limpio
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),
                  _buildCarousel(),
                  const SizedBox(height: 32),
                  _buildQuickStats(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Más Vendidos', Icons.local_fire_department),
                  const SizedBox(height: 16),
                  _buildBestSellersList(), // Aquí corregimos el overflow
                  const SizedBox(height: 32),
                  _buildPromoSection(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Beneficios', Icons.card_giftcard),
                  const SizedBox(height: 16),
                  _buildBenefitsSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, 'menu'),
        backgroundColor: const Color(0xFF6F4E37),
        icon: const Icon(Icons.restaurant_menu, color: Colors.white),
        label: const Text(
          'Ver Menú Completo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0.5,
      surfaceTintColor: Colors.white,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6F4E37),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.coffee, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Café Aroma',
                style: TextStyle(
                  color: Color(0xFF2D2D2D),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              Text(
                'Sabor auténtico',
                style: TextStyle(
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
                  icon: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Color(0xFF2D2D2D),
                    size: 26,
                  ),
                  onPressed: () => Navigator.pushNamed(context, 'orders'),
                ),
                if (cartManager.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartManager.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    final hour = DateTime.now().hour;
    String greeting = '¡Buenos días!';
    if (hour >= 12 && hour < 18) greeting = '¡Buenas tardes!';
    if (hour >= 18) greeting = '¡Buenas noches!';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '¿Qué te gustaría\ntomar hoy?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 250, // Altura del carrusel
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: carouselProducts.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.1)).clamp(0.9, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 250,
                      width: MediaQuery.of(context).size.width * 0.9, // Responsivo al ancho
                      child: child,
                    ),
                  );
                },
                child: _buildCarouselCard(carouselProducts[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            carouselProducts.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFF6F4E37)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselCard(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6F4E37).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                );
              },
            ),
            // Gradiente oscuro para que el texto resalte
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            if (product.badge != null)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.badge!,
                    style: const TextStyle(
                      color: Color(0xFF6F4E37),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6F4E37),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Text(
                          'Ordenar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildQuickActionItem(Icons.moped, 'Delivery', '25 min')),
          const SizedBox(width: 25),
          Expanded(child: _buildQuickActionItem(Icons.storefront, 'Recoger', '10 min')),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String title, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF6F4E37), size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, 'menu'),
            child: const Text(
              'Ver todo',
              style: TextStyle(color: Color(0xFF6F4E37)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellersList() {
    // CORRECCIÓN: Aumentamos la altura de 280 a 320 para evitar el Overflow
    return SizedBox(
      height: 330, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 25, right: 15),
        physics: const BouncingScrollPhysics(),
        itemCount: bestSellers.length,
        itemBuilder: (context, index) {
          return _buildProductCard(bestSellers[index], index);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product, int index) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'menu'),
      child: Container(
        width: 250, // Un poco más ancho para mejor visualización
        margin: const EdgeInsets.only(right: 16, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Stack(
              children: [
                Hero(
                  tag: 'product_${product.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      product.imageUrl,
                      height: 170, // Altura de imagen
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 170,
                        color: Colors.grey[100],
                        child: const Icon(Icons.coffee, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Información del producto
            SizedBox(
              height: 140,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF2D2D2D),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(), // Empuja el precio hacia abajo
                    
                    // Fila de Precio y Botón Agregar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          product.price,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF6F4E37),
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6F4E37),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF4A4A4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'PROMO',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Happy Hour',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '50% OFF en Lattes',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=400&h=400&fit=crop'
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildBenefitItem(Icons.card_giftcard, 'Puntos de Lealtad', 'Gana recompensas'),
          const SizedBox(height: 12),
          _buildBenefitItem(Icons.local_shipping_outlined, 'Envío Gratis', 'En pedidos +15'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6F4E37), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, true, 'Inicio'),
              _buildNavItem(Icons.favorite_border, false, 'Favoritos'),
              _buildNavItem(Icons.receipt_long, false, 'Pedidos'),
              _buildNavItem(Icons.person_outline, false, 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF6F4E37) : Colors.grey[400],
          size: 26,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF6F4E37) : Colors.grey[400],
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}