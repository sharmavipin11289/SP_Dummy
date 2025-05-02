import 'package:flutter/material.dart';

class FontStyles {
  static const String fontFamily = 'ZonaPro';

  static TextStyle getStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    TextDecoration decoration = TextDecoration.none
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }
}
