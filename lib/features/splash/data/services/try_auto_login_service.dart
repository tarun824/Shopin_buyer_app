import 'package:buyer/features/splash/data/data_sources/local/get_user_data.dart';

class TryAutoLogin {
  Future tryAutoLogin() async {
    final prefs = await GetsUserData.getsUserData();
    if (prefs == null) {
      return null;
    }

    final userId = prefs['userId'];
    return userId;
  }
}
