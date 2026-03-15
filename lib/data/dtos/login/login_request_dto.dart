class LoginRequestDto {
  final String username;
  final String password;
  final String role;

  LoginRequestDto({
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'role': role,
    };
  }

  // Dùng khi nối API sau này
  Map<String, dynamic> toJson() => toMap();
}