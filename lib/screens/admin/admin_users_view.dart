import 'package:flutter/material.dart';

class AdminUsersView extends StatelessWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulamos que los usuarios aún no se han cargado
    final users = <String>[];

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
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Text(
                        "Gestión usuarios",
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

                  /// CARD PRINCIPAL
                  Expanded(
                    child: Center(
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
                                child: const Text(
                                  "Lista de Usuarios",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
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

                              /// LISTA DE USUARIOS
                              Expanded(
                                child: users.isEmpty
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            "Cargando usuarios...",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontFamily: 'serif',
                                            ),
                                          ),
                                        ),
                                      )
                                    : ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemCount: users.length,
                                        separatorBuilder: (_, __) => Container(
                                          height: 1,
                                          color: Colors.black,
                                        ),
                                        itemBuilder: (context, index) {
                                          final isActive = index % 2 == 0;

                                          return Dismissible(
                                            key: ValueKey(users[index]),
                                            direction:
                                                DismissDirection.endToStart,
                                            background: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: 60,
                                                  color: Colors.green,
                                                  alignment: Alignment.center,
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                ),
                                                Container(
                                                  width: 60,
                                                  color: Colors.red,
                                                  alignment: Alignment.center,
                                                  child: const Icon(
                                                    Icons.delete,
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
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                                leading: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: isActive
                                                      ? const Color(0xFFF2D67B)
                                                      : const Color(0xFF5A2D2D),
                                                  child: Text(
                                                    users[index][0]
                                                        .toLowerCase(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      fontFamily: 'serif',
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  users[index],
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
                              ),
                            ],
                          ),
                        ),
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