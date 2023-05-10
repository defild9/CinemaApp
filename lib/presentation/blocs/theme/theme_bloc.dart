import 'package:cinema_app/core/style/dark_theme.dart';
import 'package:cinema_app/data/datasources/theme_storage.dart';
import 'package:cinema_app/presentation/blocs/theme/theme_event.dart';
import 'package:cinema_app/presentation/blocs/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {

  ThemeBloc() : super(ThemeLoadSuccess(themeData: ThemeData.light(), isDarkTheme: false)) {
    on<ThemeChanged>(_onThemeChanged);
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    bool isDark = await ThemeStorage.isDarkTheme;
    ThemeData themeData = isDark ? ColorTheme.darkTheme : ThemeData.light();
    emit(ThemeLoadSuccess(themeData: themeData, isDarkTheme: isDark));
  }

  Future<void> _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) async {
    await ThemeStorage.toggleTheme(event.isDarkTheme);
    await _loadTheme();
  }
}


