import 'package:flutter/material.dart';

class ThemeText {
  // Default Text Style Following Guideline
  static const headline1 = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w600,
  );
  static const headline2 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.normal,
  );
  static const bodyText2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.normal,
  );
  static const caption = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );
  static const overline = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
  );
  static const button = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.normal,
  );

  static TextTheme getDefaultTextTheme() => const TextTheme(
        headline1: ThemeText.headline1,
        headline2: ThemeText.headline2,
        bodyText1: ThemeText.bodyText1,
        bodyText2: ThemeText.bodyText2,
        subtitle1: ThemeText.subtitle1,
        caption: ThemeText.caption,
        overline: ThemeText.overline,
        button: ThemeText.button,
      );

  static const TextStyle buttonText = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    wordSpacing: 0,
  );
}
