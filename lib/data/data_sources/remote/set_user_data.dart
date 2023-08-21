
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SetUserData {
  static const _storage = FlutterSecureStorage();

  static Future setUserData(Map<String, String> userData) async {
    final value = json.encode(userData);
    print("this is encode" + value);
    await _storage.write(key: "userData", value: value);
  }

  // Future<void> delete() async {
  //   await
  // }
}
