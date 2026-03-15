import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHasher {
  // Hàm tạo mã băm SHA-256 từ chuỗi mật khẩu gốc
  static String sha256Hash(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}