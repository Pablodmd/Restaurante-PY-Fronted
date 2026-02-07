import 'package:flutter/material.dart';
import 'package:restaurante_py/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final userController = TextEditingController();
  final passController = TextEditingController();

  bool isLoading = false;

  Future<void> register() async {
    if (isLoading) return;

    final email = emailController.text.trim();
    final username = userController.text.trim();
    final password = passController.text.trim();

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService.register(
        email: email,
        username: username,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario creado correctamente")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
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
          Image.asset("assets/images/ViewBackground.png", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Image.asset("assets/images/RestaurantLogo.png", height: 200),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Registro",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'serif',
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          const Text("Introduce tu correo electrónico",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'serif')),
                          const SizedBox(height: 8),
                          _buildTextField(
                            hint: "Email",
                            icon: Icons.email_outlined,
                            controller: emailController,
                          ),

                          const SizedBox(height: 18),

                          const Text("Introduce tu nombre de usuario",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'serif')),
                          const SizedBox(height: 8),
                          _buildTextField(
                            hint: "Usuario",
                            icon: Icons.person_outline,
                            controller: userController,
                          ),

                          const SizedBox(height: 18),

                          const Text("Introduce tu contraseña",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'serif')),
                          const SizedBox(height: 8),
                          _buildTextField(
                            hint: "Contraseña",
                            icon: Icons.lock_outline,
                            controller: passController,
                            isPassword: true,
                          ),

                          const SizedBox(height: 28),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5A2D2D),
                                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Volver", style: TextStyle(color: Colors.white)),
                              ),

                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD4AF37),
                                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: isLoading ? null : register,
                                    child: const Text(
                                      "Registrarse",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  if (isLoading)
                                    const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    ),
                                ],
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
          ),
        ],
      ),
    );
  }
}
