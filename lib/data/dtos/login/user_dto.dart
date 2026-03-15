class UserDto {
  final String id;
  final String username;
  final String role;
  final String name;

  UserDto({
    required this.id,
    required this.username,
    required this.role,
    required this.name,
  });

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      id: map['id'] as String,
      username: map['username'] as String,
      role: map['role'] as String,
      name: map['name'] as String,
    );
  }
}