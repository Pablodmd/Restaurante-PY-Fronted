import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurante_py/providers/cart_provider.dart';
import 'package:restaurante_py/providers/product_provider.dart';
import 'package:restaurante_py/widgets/product_card.dart';
import '../../user/cart/cart_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Bebida',
    'Entrantes',
    'Primer plato',
    'Segundo plato',
    'Postre',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/ViewBackground.png", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.65)),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Text(
                        'Nuestra Carta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                      const Spacer(),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CartScreen()),
                              );
                            },
                          ),
                          if (cartProvider.itemCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD4AF37),
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '${cartProvider.itemCount}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 60,
                  color: Colors.black.withOpacity(0.3),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedCategoryIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFD4AF37)
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFD4AF37)
                                  : Colors.grey.shade400,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _categories[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontFamily: 'serif',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Expanded(
                  child: productProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFD4AF37),
                          ),
                        )
                      : productProvider.error != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 60,
                                    color: Color(0xFFD4AF37),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Error: ${productProvider.error}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<ProductProvider>()
                                          .loadProducts();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD4AF37),
                                    ),
                                    child: const Text(
                                      'Reintentar',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _buildProductList(productProvider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(ProductProvider productProvider) {
    final products = productProvider.getProductsByCategory(
      _categories[_selectedCategoryIndex],
    );

    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No hay productos disponibles en esta categoría',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'serif',
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}