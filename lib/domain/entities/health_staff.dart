class HealthStaff {
  final String id;
  final String username;
  final String name;
  final String? password; // Có thể null khi lấy danh sách, nhưng cần khi tạo mới

  HealthStaff({
    required this.id,
    required this.username,
    required this.name,
    this.password,
  });
}