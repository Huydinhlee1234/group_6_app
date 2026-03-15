// import '../../../domain/entities/user.dart';
// import '../../../interfaces/mapper/imapper.dart';
// import '../../dtos/login/user_dto.dart';
//
// class AuthUserFromDtoMapper implements IMapper<UserDto, User> {
//   @override
//   User map(UserDto input) {
//     return User(
//       id: input.id,
//       username: input.username,
//       password: '', // Không cần lưu password ở tầng UI sau khi login
//       role: UserRole.values.byName(input.role),
//       name: input.name,
//     );
//   }
// }

import '../../../domain/entities/user.dart';
import '../../../interfaces/mapper/imapper.dart';
import '../../dtos/login/user_dto.dart';

class AuthUserFromDtoMapper implements IMapper<UserDto, User> {
  @override
  User map(UserDto input) {
    return User(
      id: input.id,
      username: input.username,
      password: '', // Không cần lưu password ở tầng UI sau khi login
      // ✨ Map từ String sang Enum, thêm xử lý an toàn nếu role bị rỗng
      role: input.role.isNotEmpty
          ? UserRole.values.byName(input.role)
          : UserRole.healthStaff,
      name: input.name,
    );
  }
}