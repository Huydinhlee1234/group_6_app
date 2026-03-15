import 'user.dart';

class AuthSession {
  final User user;
  final String accessToken;

  AuthSession({
    required this.user,
    required this.accessToken,
  });
}