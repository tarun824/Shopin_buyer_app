import 'package:buyer/utilities/text_themes.dart';
import 'package:buyer/utilities/theme_mode_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      //This gives weather app is in darj=k or light mode
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) async {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final a = await ThemeModeService().themeModeServiceWrite(themeMode);
  }

  void setThemeModeFromRemote(theme) async {
    if (theme == ThemeMode.dark) {
      themeMode = ThemeMode.dark;
    }
    if (theme == "ThemeMode.dark") {
      themeMode = ThemeMode.dark;
      notifyListeners();
    }
    if (theme == "ThemeMode.light") {
      themeMode = ThemeMode.light;
      notifyListeners();
    }
  }

  notifyListeners();
}

class MyThemes {
  static final darkTheme = ThemeData(
      appBarTheme: const AppBarTheme(color: Color.fromRGBO(104, 126, 255, 1)),
      primaryIconTheme: const IconThemeData(color: Colors.white),
      textTheme: ThemeText.getDefaultTextTheme(),
      primaryColor: const Color.fromRGBO(104, 126, 255, 1),
      colorScheme: const ColorScheme.dark(),
      accentColor: Colors.transparent);

  static final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(color: Color.fromRGBO(104, 126, 255, 1)),
    textTheme: ThemeText.getDefaultTextTheme(),
    iconTheme: const IconThemeData(color: Colors.black),
    primaryColor: const Color.fromRGBO(104, 126, 255, 1),
    colorScheme: const ColorScheme.light(),
  );
}
