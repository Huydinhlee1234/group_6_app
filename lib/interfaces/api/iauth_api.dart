// lib/interfaces/api/iauth_api.dart
import '../../domain/entities/user.dart';

abstract class IAuthApi {
  Future<User?> login(String username, String password, UserRole role);
}

