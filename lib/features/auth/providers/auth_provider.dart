import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/auth_service.dart';

final authProvider = Provider((ref) => AuthProvider());

class AuthProvider {
  final AuthService _service = AuthService();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login({required String email, required String password}) async {
    try {
      final data = await _service.login(email: email, password: password);

      await _storage.write(key: "token", value: data["data"]["token"]);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final data = await _service.register(
        fullName: fullName,
        email: email,
        password: password,
      );

      await _storage.write(key: "token", value: data["data"]["token"]);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: "token");
  }
}
