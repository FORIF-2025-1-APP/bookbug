import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // 테마 상태 관리
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get thememode => _themeMode;

  void toggleTheme() {
    _themeMode =
        (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
