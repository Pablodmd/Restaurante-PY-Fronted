import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurante_py/screens/auth/login_screen.dart';
import 'package:restaurante_py/screens/admin/admin_users_view.dart';
import 'package:restaurante_py/screens/admin/admin_products_view.dart';
import 'package:restaurante_py/screens/admin/admin_orders_view.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Widget _adminCard(
    String imagePath,
    String label,
    Color buttonColor,
    VoidCallback onTap,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 280,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 80,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: logout,
                          ),
                        ],
                      ),
                      const Text(
                        "Menú Admin",
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

                  /// BIENVENIDA
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 320),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Bienvenido Administrador",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'serif',
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// TARJETAS
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _adminCard(
                            "assets/images/icon_users.png",
                            "Gestionar Usuarios",
                            const Color(0xFFF2D67B),
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AdminUsersView(),
                                ),
                              );
                            },
                          ),
                          _adminCard(
                              "assets/images/food.png",
                              "Gestionar Productos",
                            const Color(0xFF5A2D2D),
                              () {
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (_) => const AdminProductsView(),
                                   ),
                                );
                              },
                          ),
                          _adminCard(
                            "assets/images/order_icon.png",
                            "Gestionar Pedidos",
                          const Color(0xFFF2D67B),
                            () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AdminOrdersView(),
                                ),
                              );
                            },
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
}