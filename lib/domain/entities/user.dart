// enum UserRole { admin, healthStaff }
//
// class User {
//   final String id;
//   final String username;
//   final String password;
//   final UserRole role;
//   final String name;
//
//   User({
//     required this.id,
//     required this.username,
//     required this.password,
//     required this.role,
//     required this.name,
//   });
// }

enum UserRole {
  admin,
  healthStaff
}

class User {
  final String id;
  final String username;
  final String password;
  final UserRole role; // ✨ Đổi sang dùng Enum để UI dễ xử lý
  final String name;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.name,
  });
}