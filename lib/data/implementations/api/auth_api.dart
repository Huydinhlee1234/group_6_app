import '../../../domain/entities/user.dart';
import '../../../interfaces/api/iauth_api.dart';
import '../../dtos/login/user_dto.dart';
import '../local/app_database.dart';
import '../local/password_hasher.dart';
import '../mapper/auth_mapper.dart';


class AuthApi implements IAuthApi {
  final _fromDto = AuthUserFromDtoMapper();

  @override
  Future<User?> login(String username, String password, UserRole role) async {
    final db = await AppDatabase.instance.db;
    final hashedPw = PasswordHasher.sha256Hash(password);

    final maps = await db.query(
      'users',
      where: 'username = ? AND password_hash = ? AND role = ?',
      whereArgs: [username, hashedPw, role.name],
    );

    if (maps.isNotEmpty) {
      // Parse từ DB Map -> DTO -> Entity
      return _fromDto.map(UserDto.fromMap(maps.first));
    }
    return null;
  }
}