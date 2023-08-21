import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeModeRemoteDataSource {
  static const _storage = FlutterSecureStorage();

  static Future themeModeRemoteDataSourceWrite(
      Map<String, String> thememode) async {
    final value = json.encode(thememode);
    final isThemeData = await _storage.containsKey(key: "themeMode");
    if (isThemeData) {
      await _storage.delete(key: "themeMode");
    } else {
      await _storage.write(key: "themeMode", value: value);
    }
  }

  static Future<Map<String, String>?> themeModeRemoteDataSourceRead() async {
    final value = await _storage.read(key: "themeMode");
    return value == null ? null : Map<String, String>.from(json.decode(value));
  }
}
