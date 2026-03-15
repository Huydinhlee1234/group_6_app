// class UpdateInsertHealthStaffRequestDto {
//   final String? id; // Null khi Insert, có giá trị khi Update
//   final String username;
//   final String password;
//   final String name;
//
//   UpdateInsertHealthStaffRequestDto({
//     this.id,
//     required this.username,
//     required this.password,
//     required this.name,
//   });
//
//   Map<String, dynamic> toMap() {
//     final map = <String, dynamic>{
//       'username': username,
//       'password': password,
//       'name': name,
//     };
//
//     // Nếu có ID (trường hợp Update) thì thêm vào
//     if (id != null) {
//       map['id'] = id;
//     }
//
//     return map;
//   }
// }

class UpdateInsertHealthStaffRequestDto {
  final String? id; // Null khi Insert, có giá trị khi Update
  final String username;
  final String password;
  final String role; // ✨ BỔ SUNG: Khai báo thêm role
  final String name;

  UpdateInsertHealthStaffRequestDto({
    this.id,
    required this.username,
    required this.password,
    required this.role, // ✨ BỔ SUNG: Yêu cầu truyền role
    required this.name,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'username': username,
      'password_hash': password, // ✨ SỬA LỖI ĐỎ: Đổi từ 'password' thành 'password_hash'
      'role': role,              // ✨ BỔ SUNG: Đẩy role xuống database
      'name': name,
    };

    // Nếu có ID (trường hợp Update) thì thêm vào
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}