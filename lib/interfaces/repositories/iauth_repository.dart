import '../../domain/entities/user.dart';

abstract class IAuthRepository {
  /// Hàm đăng nhập, trả về User nếu thành công, trả về null nếu thất bại
  Future<User?> login(String username, String password, UserRole role);

  /// Hàm đăng xuất
  Future<void> logout();

  /// Lấy thông tin user đang đăng nhập hiện tại (nếu có)
  Future<User?> getCurrentUser();
}