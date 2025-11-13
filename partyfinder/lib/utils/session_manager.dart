import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionManager {
  static final _storage = FlutterSecureStorage(); // <- cambiar const -> final
  static const _keyToken = 'jwt';
  static const _keyFirstName = 'first_name';
  static const _keyLastName = 'last_name';
  static const _keyEmail = 'email';
  static const _keyBirthDate = 'birth_date';
  static const _keyImagePath = 'image_path';

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
    await _storage.delete(key: _keyFirstName);
    await _storage.delete(key: _keyLastName);
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyBirthDate);
  }

  // Guarda nombre y apellido
  static Future<void> saveName(String firstName, String lastName) async {
    await _storage.write(key: _keyFirstName, value: firstName);
    await _storage.write(key: _keyLastName, value: lastName);
  }

  static Future<String?> getFirstName() async {
    return await _storage.read(key: _keyFirstName);
  }

  static Future<String?> getLastName() async {
    return await _storage.read(key: _keyLastName);
  }

  static Future<String?> getFullName() async {
    final f = await getFirstName();
    final l = await getLastName();
    if ((f == null || f.isEmpty) && (l == null || l.isEmpty)) return null;
    return '${f ?? ''}${(f != null && f.isNotEmpty && l != null && l.isNotEmpty) ? ' ' : ''}${l ?? ''}'.trim();
  }

  // Guarda email
  static Future<void> saveEmail(String email) async {
    await _storage.write(key: _keyEmail, value: email);
  }

  static Future<String?> getEmail() async {
    return await _storage.read(key: _keyEmail);
  }

  // Guarda fecha de nacimiento en formato YYYY-MM-DD
  static Future<void> saveBirthDate(String birthDate) async {
    await _storage.write(key: _keyBirthDate, value: birthDate);
  }

  static Future<String?> getBirthDate() async {
    return await _storage.read(key: _keyBirthDate);
  }

  // Guarda la ruta local de la imagen de perfil
  static Future<void> saveImagePath(String path) async {
    await _storage.write(key: _keyImagePath, value: path);
  }

  // Obtiene la ruta local de la imagen de perfil
  static Future<String?> getImagePath() async {
    return await _storage.read(key: _keyImagePath);
  }
}
