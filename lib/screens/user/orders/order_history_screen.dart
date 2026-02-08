import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurante_py/providers/order_provider.dart';
import 'package:restaurante_py/widgets/order_card.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
    });
  }

  Future<void> _refreshOrders() async {
    await context.read<OrderProvider>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final completedOrders = orderProvider.getOrderHistory();

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
                        'Historial de Pedidos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _refreshOrders,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: orderProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFD4AF37),
                          ),
                        )
                      : orderProvider.error != null
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
                                    'Error: ${orderProvider.error}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _refreshOrders,
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
                          : completedOrders.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.receipt_long_outlined,
                                        size: 100,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No tienes pedidos completados',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white.withOpacity(0.8),
                                          fontFamily: 'serif',
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: _refreshOrders,
                                  color: const Color(0xFFD4AF37),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: completedOrders.length,
                                    itemBuilder: (context, index) {
                                      return OrderCard(
                                        order: completedOrders[index],
                                        isActive: false,
                                      );
                                    },
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