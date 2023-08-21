import 'package:flutter/material.dart';

class LocalProvider extends ChangeNotifier {
  Locale _locale = Locale("en");

  Locale get locale {
    return _locale;
  }

  void setLocal(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  String findLanguage() {
    if (_locale == Locale("en")) {
      return "english";
    }
    if (_locale == Locale("kn")) {
      return "kannada";
    } else {
      return "english";
    }
  }
}
