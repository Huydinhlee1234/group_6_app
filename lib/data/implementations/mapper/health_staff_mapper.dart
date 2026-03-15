// import '../../../domain/entities/user.dart';
// import '../../../interfaces/mapper/imapper.dart';
// import '../../dtos/health_staff/health_staff_dto.dart';
// import '../../dtos/health_staff/update_insert_health_staff_request_dto.dart';
//
// class HealthStaffFromDtoMapper implements IMapper<HealthStaffDto, User> {
//   @override
//   User map(HealthStaffDto input) {
//     return User(
//       id: input.id,
//       username: input.username,
//       password: '', // Khi fetch list không lấy pass
//       role: UserRole.healthStaff,
//       name: input.name,
//     );
//   }
// }
//
// class HealthStaffToDtoMapper implements IMapper<User, UpdateInsertHealthStaffRequestDto> {
//   @override
//   UpdateInsertHealthStaffRequestDto map(User input) {
//     return UpdateInsertHealthStaffRequestDto(
//       id: input.id,
//       username: input.username,
//       password: input.password, // Mật khẩu gốc sẽ được hash ở API trước khi biến thành DTO (tùy chọn)
//       name: input.name,
//     );
//   }
// }

import '../../../domain/entities/user.dart';
import '../../../interfaces/mapper/imapper.dart';
import '../../dtos/health_staff/health_staff_dto.dart';
import '../../dtos/health_staff/update_insert_health_staff_request_dto.dart';

class HealthStaffFromDtoMapper implements IMapper<HealthStaffDto, User> {
  @override
  User map(HealthStaffDto input) {
    return User(
      id: input.id,
      username: input.username,
      password: '', // Khi fetch list không lấy pass
      role: UserRole.healthStaff, // Dùng thẳng Enum
      name: input.name,
    );
  }
}

class HealthStaffToDtoMapper implements IMapper<User, UpdateInsertHealthStaffRequestDto> {
  @override
  UpdateInsertHealthStaffRequestDto map(User input) {
    return UpdateInsertHealthStaffRequestDto(
      id: input.id,
      username: input.username,
      password: input.password,
      role: input.role.name, // ✨ ĐÃ BỔ SUNG: Chuyển Enum thành String để DTO lưu DB
      name: input.name,
    );
  }
}