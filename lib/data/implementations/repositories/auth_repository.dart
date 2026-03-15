import '../../../domain/entities/user.dart';
import '../../../interfaces/api/iauth_api.dart';
import '../../../interfaces/repositories/iauth_repository.dart';

class AuthRepository implements IAuthRepository {
  final IAuthApi _api;
  User? _currentUser; // Lưu trữ session cục bộ

  AuthRepository(this._api);

  @override
  Future<User?> login(String username, String password, UserRole role) async {
    final user = await _api.login(username, password, role);
    if (user != null) {
      _currentUser = user;
    }
    return user;
  }

  @override
  Future<void> logout() async {
    // Xóa session cục bộ, xóa token trong SharedPreferences/SecureStorage nếu có
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    // Thường lấy từ Local Storage (SecureStorage) khi app vừa khởi động
    return _currentUser;
  }
}