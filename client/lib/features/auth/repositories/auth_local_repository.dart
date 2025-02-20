import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository (ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Null or String, if Null, user is not logged in
  void setToken(String? token) {
    if (token != null) {
      _sharedPreferences.setString('x-auth-token', token);
      return;
    }
  }

  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }
}