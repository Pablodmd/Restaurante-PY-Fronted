import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:restaurante_py/models/order.dart';
import 'package:restaurante_py/providers/order_provider.dart';
import 'package:intl/intl.dart';

class AdminOrdersView extends StatefulWidget {
  const AdminOrdersView({super.key});

  @override
  State<AdminOrdersView> createState() => _AdminOrdersViewState();
}

class _AdminOrdersViewState extends State<AdminOrdersView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OrderProvider>().loadAllOrders(),
    );
  }

  Future<void> _showOrderDetails(Order order) async {
    await showDialog(
      context: context,
      builder: (context) => OrderDetailsDialog(order: order),
    );
  }

  Color _getAvatarColor(int index) {
    return index % 2 == 0
        ? const Color(0xFFF2D67B)
        : const Color(0xFF5A2D2D);
  }

  String _getStatusText(String status) {
    return status;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pendiente':
        return Colors.orange;
      case 'En proceso':
        return Colors.blue;
      case 'Entregado':
      case 'Completado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/ViewBackground.png", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
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
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: _buildOrdersSections(),
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

  Widget _buildOrdersSections() {
    return Consumer<OrderProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFF2D67B)),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadAllOrders(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2D67B),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Reintentar',
                      style: TextStyle(fontFamily: 'serif'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final activeOrders = provider.getActiveOrders();
        final completedOrders = provider.getOrderHistory();

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildOrderSection(
                title: "Pedidos Pendientes",
                orders: activeOrders,
                isEmpty: activeOrders.isEmpty,
              ),
              const SizedBox(height: 16),
              _buildOrderSection(
                title: "Pedidos Finalizados",
                orders: completedOrders,
                isEmpty: completedOrders.isEmpty,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderSection({
    required String title,
    required List<Order> orders,
    required bool isEmpty,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
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
          Container(height: 2, color: Colors.black),
          if (isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "No hay pedidos",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontFamily: 'serif',
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: orders.length,
              separatorBuilder: (_, __) => Container(height: 1, color: Colors.black),
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderItem(order, index);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Order order, int index) {
    return Slidable(
      key: ValueKey(order.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (context) async {
              Slidable.of(context)?.close();
              await Future.delayed(const Duration(milliseconds: 100));
              _showOrderDetails(order);
            },
            backgroundColor: const Color(0xFFF2D67B),
            foregroundColor: Colors.black,
            icon: Icons.edit,
            label: 'Editar',
          ),
          SlidableAction(
            onPressed: (context) async {
              Slidable.of(context)?.close();
              await Future.delayed(const Duration(milliseconds: 100));
              _showOrderDetails(order);
            },
            backgroundColor: const Color(0xFF64B5F6),
            foregroundColor: Colors.white,
            icon: Icons.info,
            label: 'Detalles',
          ),
        ],
      ),
      child: Container(
        color: const Color(0xFFE8E8E8),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: _getAvatarColor(index),
            child: Text(
              'P',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'serif',
              ),
            ),
          ),
          title: Text(
            'Pedido ${order.id}',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'serif',
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            'Mesa ${order.tableNumber} • ${order.total.toStringAsFixed(2)}€',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'serif',
              color: Colors.black54,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(order.status),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getStatusText(order.status),
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'serif',
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_left, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailsDialog extends StatefulWidget {
  final Order order;

  const OrderDetailsDialog({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsDialog> createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends State<OrderDetailsDialog> {
  late String _selectedStatus;
  bool _isLoading = false;

  final List<String> _statuses = [
    'Pendiente',
    'En proceso',
    'Entregado',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status;
  }

  Future<void> _updateStatus() async {
    if (_selectedStatus == widget.order.status) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = context.read<OrderProvider>();
      await provider.updateOrderStatus(widget.order.id!, _selectedStatus);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Estado actualizado correctamente',
              style: TextStyle(fontFamily: 'serif'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: const TextStyle(fontFamily: 'serif'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Dialog(
      backgroundColor: const Color(0xFFE8E8E8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detalles del Pedido',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 20),

              _buildReadOnlyField('Pedido #', '${widget.order.id}'),
              const SizedBox(height: 12),

              _buildReadOnlyField('Mesa', '${widget.order.tableNumber}'),
              const SizedBox(height: 12),

              _buildReadOnlyField(
                'Fecha',
                widget.order.dateOrder != null
                    ? dateFormat.format(widget.order.dateOrder!)
                    : 'N/A',
              ),
              const SizedBox(height: 12),

              _buildReadOnlyField(
                'Total',
                '${widget.order.total.toStringAsFixed(2)}€',
              ),
              const SizedBox(height: 20),

              const Text(
                'Productos:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 8),

              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.order.orderLines.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final line = widget.order.orderLines[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        line.product.name,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 14,
                        ),
                      ),
                      subtitle: line.notes != null && line.notes!.isNotEmpty
                          ? Text(
                              'Nota: ${line.notes}',
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : null,
                      trailing: Text(
                        '${line.amount}x ${line.price.toStringAsFixed(2)}€',
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Estado del pedido:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _statuses.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      status,
                      style: const TextStyle(fontFamily: 'serif'),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _updateStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2D67B),
                      foregroundColor: Colors.black,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Guardar',
                            style: TextStyle(fontFamily: 'serif'),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'serif',
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'serif',
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}