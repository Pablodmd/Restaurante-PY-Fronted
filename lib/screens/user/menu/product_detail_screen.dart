import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurante_py/models/product.dart';
import 'package:restaurante_py/providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFFD4AF37).withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu,
                            size: 120,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'serif',
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD4AF37),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      widget.product.category,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'serif',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.access_time, size: 20, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.product.preparationTime.toInt()} min',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Descripción',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'serif',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.product.description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Notas adicionales (opcional)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'serif',
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _notesController,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Ej: Sin cebolla, poco picante...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.9),
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Precio',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontFamily: 'serif',
                                          ),
                                        ),
                                        Text(
                                          '${widget.product.price.toStringAsFixed(2)} €',
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFD4AF37),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        final notes = _notesController.text.trim();
                                        context.read<CartProvider>().addProduct(
                                          widget.product,
                                          notes: notes.isEmpty ? null : notes,
                                        );
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${widget.product.name} añadido al carrito'),
                                            duration: const Duration(seconds: 2),
                                            backgroundColor: const Color(0xFF5A2D2D),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.add_shopping_cart, color: Colors.black),
                                      label: const Text(
                                        'Añadir',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'serif',
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFD4AF37),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}