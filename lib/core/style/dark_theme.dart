import 'package:cinema_app/core/style/colors.dart';
import 'package:flutter/material.dart';

class ColorTheme{
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: CColors.grey,
    backgroundColor: CColors.black,
    scaffoldBackgroundColor: CColors.black,
  );
}