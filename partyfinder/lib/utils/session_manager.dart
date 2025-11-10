import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  static final _storage = FlutterSecureStorage(); // <- cambiar const -> final
  static const _keyToken = 'jwt';

  // Guarda el token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Obtiene el token
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Verifica si el usuario ya tiene sesión iniciada
  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _keyToken);
    return token != null && token.isNotEmpty;
  }

  // Cierra sesión (borra el token)
  static Future<void> clearSession() async {
    await _storage.delete(key: _keyToken);
  }
}
