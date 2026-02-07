import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:restaurante_py/models/user.dart';
import 'package:restaurante_py/services/user_service.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  final UserService _userService = UserService();

  List<User> _users = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await _userService.getAllUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar usuarios';
        _isLoading = false;
      });
    }
  }

  Future<void> _showDeleteConfirmation(User user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFE8E8E8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Confirmar eliminación',
          style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.w500),
        ),
        content: Text(
          '¿Deseas desactivar al usuario "${user.username}"?',
          style: const TextStyle(fontFamily: 'serif'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.black54, fontFamily: 'serif'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(
              'Desactivar',
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _deleteUser(user);
    }
  }

  Future<void> _deleteUser(User user) async {
    try {
      await _userService.deleteUser(user.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Usuario "${user.username}" desactivado',
              style: const TextStyle(fontFamily: 'serif'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }

      await _loadUsers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Error al desactivar usuario',
              style: TextStyle(fontFamily: 'serif'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  Color _getAvatarColor(int index) {
    return index % 2 == 0 
        ? const Color(0xFFF2D67B)
        : const Color(0xFF5A2D2D);
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

                              Container(height: 2, color: Colors.black),

                              Expanded(child: _buildUsersList()),
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

  Widget _buildUsersList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF2D67B)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUsers,
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

    if (_users.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "No hay usuarios registrados",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontFamily: 'serif',
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _users.length,
      separatorBuilder: (_, __) => Container(height: 1, color: Colors.black),
      itemBuilder: (context, index) {
        final user = _users[index];

        return Slidable(
          key: ValueKey(user.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.25, // Ocupa el 25% del ancho
            children: [
              SlidableAction(
                onPressed: (context) {
                  _showDeleteConfirmation(user);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: '',
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
                  user.username.isNotEmpty
                      ? user.username[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'serif',
                  ),
                ),
              ),
              title: Text(
                user.username,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: 'serif',
                  color: Colors.black,
                ),
              ),
              subtitle: user.email.isNotEmpty
                  ? Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'serif',
                        color: Colors.black54,
                      ),
                    )
                  : null,
              trailing: const Icon(Icons.chevron_left, color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}