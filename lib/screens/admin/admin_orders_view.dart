import 'package:flutter/material.dart';

class AdminOrdersView extends StatelessWidget {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulamos que los pedidos aún no se han cargado
    final pendingOrders = <String>[];
    final completedOrders = <String>[];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/ViewBackground.png",
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// HEADER
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Text(
                        "Gestión Pedidos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'serif',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// CARDS DE PEDIDOS
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /// CARD PEDIDOS PENDIENTES
                          _buildOrderCard(
                            title: "Pedidos Pendientes",
                            orders: pendingOrders,
                            isPending: true,
                          ),

                          const SizedBox(height: 16),

                          /// CARD PEDIDOS FINALIZADOS
                          _buildOrderCard(
                            title: "Pedidos Finalizados",
                            orders: completedOrders,
                            isPending: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required String title,
    required List<String> orders,
    required bool isPending,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              /// TÍTULO DE LA CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'serif',
                    color: Colors.black,
                  ),
                ),
              ),

              /// SEPARADOR
              Container(
                height: 2,
                color: Colors.black,
              ),

              /// LISTA DE PEDIDOS
              orders.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Cargando pedidos...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontFamily: 'serif',
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => Container(
                        height: 1,
                        color: Colors.black,
                      ),
                      itemBuilder: (context, index) {
                        final isYellow = index % 2 == 0;

                        return Dismissible(
                          key: ValueKey(orders[index]),
                          direction: DismissDirection.endToStart,
                          background: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (isPending)
                                Container(
                                  width: 60,
                                  color: const Color(0xFFF2D67B),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              if (!isPending)
                                Container(
                                  width: 60,
                                  color: const Color(0xFF64B5F6),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                            ],
                          ),
                          confirmDismiss: (_) async {
                            return false;
                          },
                          child: Container(
                            color: const Color(0xFFE8E8E8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: isYellow
                                    ? const Color(0xFFF2D67B)
                                    : const Color(0xFF5A2D2D),
                                child: Text(
                                  orders[index][0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'serif',
                                  ),
                                ),
                              ),
                              title: Text(
                                orders[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  fontFamily: 'serif',
                                  color: Colors.black,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_left,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}