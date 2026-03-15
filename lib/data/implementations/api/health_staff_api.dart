// import '../../../domain/entities/user.dart';
// import '../../../interfaces/api/iheath_staff_api.dart';
// import '../../dtos/health_staff/health_staff_dto.dart';
// import '../local/app_database.dart';
// import '../local/password_hasher.dart';
// import '../mapper/health_staff_mapper.dart';
//
//
// class HealthStaffApi implements IHealthStaffApi {
//   final _fromDto = HealthStaffFromDtoMapper();
//   final _toDto = HealthStaffToDtoMapper();
//   final String _roleName = UserRole.healthStaff.name;
//
//   @override
//   Future<List<User>> getAllHealthStaff() async {
//     final db = await AppDatabase.instance.db;
//     final maps = await db.query('users', where: 'role = ?', whereArgs: [_roleName]);
//     return maps.map((map) => _fromDto.map(HealthStaffDto.fromMap(map))).toList();
//   }
//
//   @override
//   Future<User> createHealthStaff(User staff) async {
//     final db = await AppDatabase.instance.db;
//
//     // Hash password, map to DTO, then toMap() for DB
//     final hashedStaff = User(
//       id: staff.id, username: staff.username, name: staff.name, role: staff.role,
//       password: PasswordHasher.sha256Hash(staff.password),
//     );
//
//     await db.insert('users', _toDto.map(hashedStaff).toMap());
//     return hashedStaff;
//   }
//
//   @override
//   Future<User> updateHealthStaff(User staff) async {
//     final db = await AppDatabase.instance.db;
//
//     final hashedStaff = User(
//       id: staff.id, username: staff.username, name: staff.name, role: staff.role,
//       password: PasswordHasher.sha256Hash(staff.password),
//     );
//
//     await db.update('users', _toDto.map(hashedStaff).toMap(), where: 'id = ? AND role = ?', whereArgs: [staff.id, _roleName]);
//     return hashedStaff;
//   }
//
//   @override
//   Future<void> deleteHealthStaff(String id) async {
//     final db = await AppDatabase.instance.db;
//     await db.delete('users', where: 'id = ? AND role = ?', whereArgs: [id, _roleName]);
//   }
// }

// import 'package:sqflite/sqflite.dart';
// import '../../../domain/entities/user.dart'; // Nhờ import này mà file sẽ hiểu UserRole là gì
// import '../../../interfaces/api/iheath_staff_api.dart';
// import '../../dtos/health_staff/health_staff_dto.dart';
// import '../local/app_database.dart';
// import '../local/password_hasher.dart';
// import '../mapper/health_staff_mapper.dart';
//
// class HealthStaffApi implements IHealthStaffApi {
//   final _fromDto = HealthStaffFromDtoMapper();
//   final _toDto = HealthStaffToDtoMapper();
//
//   // Biến này giờ đã hợp lệ vì UserRole đã được khai báo ở trên
//   final String _roleName = UserRole.healthStaff.name;
//
//   @override
//   Future<List<User>> getAllHealthStaff() async {
//     final db = await AppDatabase.instance.db;
//     final maps = await db.query('users', where: 'role = ?', whereArgs: [_roleName]);
//     return maps.map((map) => _fromDto.map(HealthStaffDto.fromMap(map))).toList();
//   }
//
//   @override
//   Future<User> createHealthStaff(User staff) async {
//     final db = await AppDatabase.instance.db;
//
//     final hashedStaff = User(
//       id: staff.id,
//       username: staff.username,
//       name: staff.name,
//       // ✨ Ép cứng role là healthStaff để an toàn tuyệt đối
//       role: _roleName,
//       password: PasswordHasher.sha256Hash(staff.password),
//     );
//
//     await db.insert('users', _toDto.map(hashedStaff).toMap());
//     return hashedStaff;
//   }
//
//   @override
//   Future<User> updateHealthStaff(User staff) async {
//     final db = await AppDatabase.instance.db;
//
//     final hashedStaff = User(
//       id: staff.id,
//       username: staff.username,
//       name: staff.name,
//       // ✨ Ép cứng role
//       role: _roleName,
//       password: PasswordHasher.sha256Hash(staff.password),
//     );
//
//     await db.update('users', _toDto.map(hashedStaff).toMap(), where: 'id = ? AND role = ?', whereArgs: [staff.id, _roleName]);
//     return hashedStaff;
//   }
//
//   @override
//   Future<void> deleteHealthStaff(String id) async {
//     final db = await AppDatabase.instance.db;
//     await db.delete('users', where: 'id = ? AND role = ?', whereArgs: [id, _roleName]);
//   }
// }

import 'package:sqflite/sqflite.dart';
import '../../../domain/entities/user.dart';
import '../../../interfaces/api/iheath_staff_api.dart';
import '../../dtos/health_staff/health_staff_dto.dart';
import '../local/app_database.dart';
import '../local/password_hasher.dart';
import '../mapper/health_staff_mapper.dart';

class HealthStaffApi implements IHealthStaffApi {
  final _fromDto = HealthStaffFromDtoMapper();
  final _toDto = HealthStaffToDtoMapper();

  // Biến String này chỉ dùng để query với SQLite (vì SQLite không hiểu Enum)
  final String _roleName = UserRole.healthStaff.name;

  @override
  Future<List<User>> getAllHealthStaff() async {
    final db = await AppDatabase.instance.db;
    final maps = await db.query('users', where: 'role = ?', whereArgs: [_roleName]);
    return maps.map((map) => _fromDto.map(HealthStaffDto.fromMap(map))).toList();
  }

  @override
  Future<User> createHealthStaff(User staff) async {
    final db = await AppDatabase.instance.db;

    final hashedStaff = User(
      id: staff.id,
      username: staff.username,
      name: staff.name,
      // ✨ FIX: Truyền thẳng Enum vào thay vì String
      role: UserRole.healthStaff,
      password: PasswordHasher.sha256Hash(staff.password),
    );

    await db.insert('users', _toDto.map(hashedStaff).toMap());
    return hashedStaff;
  }

  @override
  Future<User> updateHealthStaff(User staff) async {
    final db = await AppDatabase.instance.db;

    final hashedStaff = User(
      id: staff.id,
      username: staff.username,
      name: staff.name,
      // ✨ FIX: Truyền thẳng Enum vào thay vì String
      role: UserRole.healthStaff,
      password: PasswordHasher.sha256Hash(staff.password),
    );

    await db.update('users', _toDto.map(hashedStaff).toMap(), where: 'id = ? AND role = ?', whereArgs: [staff.id, _roleName]);
    return hashedStaff;
  }

  @override
  Future<void> deleteHealthStaff(String id) async {
    final db = await AppDatabase.instance.db;
    await db.delete('users', where: 'id = ? AND role = ?', whereArgs: [id, _roleName]);
  }
}