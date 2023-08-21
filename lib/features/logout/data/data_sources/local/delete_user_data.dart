import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeleteUserData {
  static const _storage = FlutterSecureStorage();

  static Future deleteUserData() async {
    //** This will delete the data that has key name as userData
    await _storage.delete(key: 'userData');
  }
}
