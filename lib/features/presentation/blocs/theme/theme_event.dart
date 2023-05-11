abstract class ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final bool isDarkTheme;

  ThemeChanged({required this.isDarkTheme});
}
