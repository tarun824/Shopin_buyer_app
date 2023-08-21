import 'package:buyer/utilities/theme_mode_remote_data_source.dart';

class ThemeModeService {
  Future themeModeServiceWrite(themeMode) async {
    final sendJson = {"themeMode": themeMode.toString()};
    await ThemeModeRemoteDataSource.themeModeRemoteDataSourceWrite(sendJson);
  }

  Future themeModeServiceTryToGetThemeMode() async {
    final prefs =
        await ThemeModeRemoteDataSource.themeModeRemoteDataSourceRead();
    if (prefs == null) {
      return null;
    }

    final themeMode = prefs['themeMode'];

    return themeMode;
  }
}
