import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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

          Container(color: Colors.black.withOpacity(0.6)),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/RestaurantLogo.png",
                      height: 200,
                    ),

                    const SizedBox(height: 0),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 28),
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

                          const Text(
                            "Introduce tu correo electrónico",
                            style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.w600,
                                fontFamily: 'serif'),  
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            hint: "Email",
                            icon: Icons.email_outlined,
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            "Introduce tu nombre de usuario",
                            style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.w600,
                                fontFamily: 'serif'),
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            hint: "Usuario",
                            icon: Icons.person_outline,
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            "Introduce tu contraseña",
                            style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.w600,
                                fontFamily: 'serif'),
                          ),
                          const SizedBox(height: 8),
                          _buildTextField(
                            hint: "Contraseña",
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),

                          const SizedBox(height: 28),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5A2D2D),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 26, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Volver",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD4AF37),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 26, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "Registrarse",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
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
          ),
        ],
      ),
    );
  }

  static Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
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
}
