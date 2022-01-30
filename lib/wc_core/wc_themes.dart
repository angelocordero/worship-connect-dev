import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WCThemeProvider extends StateNotifier<ThemeMode> {
  WCThemeProvider() : super(ThemeMode.dark);

  static SharedPreferences? _prefs;

  final String _themeKey = 'theme';

  init() async {
    _prefs = await SharedPreferences.getInstance();

    String? _themeString = _prefs!.getString(_themeKey);

    if (_themeString == null) {
      return;
    }

    toggleTheme(EnumToString.fromString(ThemeMode.values, _themeString)!);
  }

  toggleTheme(ThemeMode _currentTheme) async {
    if (state == _currentTheme) {
      return;
    }

    state = _currentTheme;
    await _prefs!.setString(_themeKey, state.name);
  }

  Future<String> getCurrentThemeName() async {
    switch (state) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }
}
