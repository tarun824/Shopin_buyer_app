import 'package:buyer/utilities/constants.dart';
import 'package:flutter/material.dart';

class TextfieldInputDecoration {
  static const textFieldborderRadius = Constants.textFieldBorderRadius;

  InputDecoration textfieldInputDecoration(
      String labelText, String hintText, String errorText) {
    //st parameter label,2nd hint Text ,3rd Error message
    return InputDecoration(
      hintText: "  $hintText",
      contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 18),
      enabledBorder: const OutlineInputBorder(
        borderRadius: textFieldborderRadius,
      ),
    );
  }
}
