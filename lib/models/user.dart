class User {
  final int id;
  final String username;
  final String email;
  final String role;
  final bool deleted;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.deleted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'] ?? '',
      deleted: json['deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "role": role,
      "deleted": deleted,
    };
  }
}
