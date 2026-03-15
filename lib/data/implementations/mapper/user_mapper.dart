// import '../../../domain/entities/user.dart';
// import '../../../interfaces/mapper/imapper.dart';
//
//
// class UserFromMapMapper implements IMapper<Map<String, dynamic>, User> {
//   @override
//   User map(Map<String, dynamic> input) {
//     return User(
//       id: input['id'] as String,
//       username: input['username'] as String,
//       password: input['password_hash'] as String,
//       role: UserRole.values.byName(input['role'] as String),
//       name: input['name'] as String,
//     );
//   }
// }
//
// class UserToMapMapper implements IMapper<User, Map<String, dynamic>> {
//   @override
//   Map<String, dynamic> map(User input) {
//     return {
//       'id': input.id,
//       'username': input.username,
//       'password_hash': input.password,
//       'role': input.role.name,
//       'name': input.name,
//     };
//   }
// }

import '../../../domain/entities/user.dart';
import '../../../interfaces/mapper/imapper.dart';

class UserFromMapMapper implements IMapper<Map<String, dynamic>, User> {
  @override
  User map(Map<String, dynamic> input) {
    return User(
      id: input['id'] as String,
      username: input['username'] as String,
      password: input['password_hash'] as String,
      role: UserRole.values.byName(input['role'] as String), // Chuyển String DB sang Enum
      name: input['name'] as String,
    );
  }
}

class UserToMapMapper implements IMapper<User, Map<String, dynamic>> {
  @override
  Map<String, dynamic> map(User input) {
    return {
      'id': input.id,
      'username': input.username,
      'password_hash': input.password,
      'role': input.role.name, // Chuyển Enum sang String DB
      'name': input.name,
    };
  }
}