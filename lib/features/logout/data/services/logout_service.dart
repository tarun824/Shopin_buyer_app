import 'package:buyer/data/data_sources/remote/set_user_data.dart';
import 'package:buyer/features/logout/data/data_sources/local/delete_user_data.dart';

class Logoutservice {
  Future<void> logout() async {
    // ** will call deleteUserData to delete the user data in local Secure storge
    DeleteUserData.deleteUserData();
  }
}
