class HealthStaffDto {
  final String id;
  final String username;
  final String name;

  HealthStaffDto({
    required this.id,
    required this.username,
    required this.name,
  });

  factory HealthStaffDto.fromMap(Map<String, dynamic> map) {
    return HealthStaffDto(
      id: map['id'] as String,
      username: map['username'] as String,
      name: map['name'] as String,
    );
  }
}