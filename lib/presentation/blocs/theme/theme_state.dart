import 'package:flutter/material.dart';

abstract class ThemeState {}

class ThemeLoadSuccess extends ThemeState {
  final ThemeData themeData;
  final bool isDarkTheme;

  ThemeLoadSuccess({required this.themeData, required this.isDarkTheme});
}