import 'user_dto.dart';

class LoginResponseDto {
  final String token;
  final UserDto user;

  LoginResponseDto({
    required this.token,
    required this.user,
  });

  factory LoginResponseDto.fromMap(Map<String, dynamic> map) {
    return LoginResponseDto(
      token: map['token'] as String,
      // Đảm bảo map['user'] là một Map hợp lệ trước khi parse
      user: UserDto.fromMap(map['user'] as Map<String, dynamic>),
    );
  }
}