import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurante_py/models/order.dart';
import 'package:restaurante_py/providers/cart_provider.dart';
import 'package:restaurante_py/providers/order_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _tableController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    if (cartProvider.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El carrito está vacío'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final tableNumber = int.tryParse(_tableController.text.trim());
    if (tableNumber == null || tableNumber <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, introduce un número de mesa válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    final order = Order(
      status: 'PENDING',
      total: cartProvider.totalAmount,
      tableNumber: tableNumber,
      orderLines: cartProvider.items,
    );

    final success = await orderProvider.createOrder(order);

    setState(() => _isProcessing = false);

    if (success && mounted) {
      cartProvider.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido realizado con éxito'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.error ?? 'Error al realizar el pedido'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        'Mi Carrito',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: cartProvider.items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                  size: 100, color: Colors.white.withOpacity(0.5)),
                              const SizedBox(height: 16),
                              Text(
                                'Tu carrito está vacío',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.8),
                                  fontFamily: 'serif',
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cartProvider.items.length,
                          itemBuilder: (context, index) {
                            final item = cartProvider.items[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              color: Colors.white.withOpacity(0.95),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.product.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'serif',
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${item.price.toStringAsFixed(2)} € x ${item.amount}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              if (item.notes != null &&
                                                  item.notes!.isNotEmpty) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Nota: ${item.notes}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${item.subtotal.toStringAsFixed(2)} €',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF5A2D2D),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                cartProvider.updateQuantity(
                                                    index, item.amount - 1);
                                              },
                                              icon: const Icon(
                                                  Icons.remove_circle_outline),
                                              color: const Color(0xFF5A2D2D),
                                            ),
                                            Text(
                                              '${item.amount}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                cartProvider.updateQuantity(
                                                    index, item.amount + 1);
                                              },
                                              icon: const Icon(
                                                  Icons.add_circle_outline),
                                              color: const Color(0xFF5A2D2D),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            cartProvider.removeItem(index);
                                          },
                                          icon: const Icon(Icons.delete_outline),
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (cartProvider.items.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _tableController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Número de mesa',
                            labelStyle: const TextStyle(color: Colors.black87),
                            hintText: 'Ej: 5',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.table_restaurant,
                                color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'serif',
                              ),
                            ),
                            Text(
                              '${cartProvider.totalAmount.toStringAsFixed(2)} €',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD4AF37),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isProcessing ? null : _placeOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isProcessing
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    'Realizar Pedido',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'serif',
                                    ),
                                  ),
                          ),
                        ),
                      ],
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