import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../interfaces/repositories/iauth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final IAuthRepository _authRepository;

  LoginViewModel(this._authRepository);

  String _username = '';
  String _password = '';
  UserRole _selectedRole = UserRole.admin;
  String _error = '';
  bool _isLoading = false;

  String get username => _username;
  String get password => _password;
  UserRole get selectedRole => _selectedRole;
  String get error => _error;
  bool get isLoading => _isLoading;

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<User?> handleLogin() async {
    _error = '';

    if (_username.trim().isEmpty) {
      _error = 'Vui lòng nhập tên đăng nhập';
      notifyListeners();
      return null;
    }

    if (_password.trim().isEmpty) {
      _error = 'Vui lòng nhập mật khẩu';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    notifyListeners();

    // Giả sử repository gọi tới Mock Database
    final user = await _authRepository.login(_username, _password, _selectedRole);

    _isLoading = false;

    if (user == null) {
      _error = 'Tên đăng nhập, mật khẩu hoặc vai trò không đúng';
    }

    notifyListeners();
    return user;
  }
}