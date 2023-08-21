import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GetsUserData {
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, String>?> getsUserData() async {
    final value = await _storage.read(key: "userData");
    return value == null ? null : Map<String, String>.from(json.decode(value));
  }
}
