import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeNotifier with ChangeNotifier {
  bool _isDarkTheme = false;

  DarkThemeNotifier() {
    _loadDarkPref();
  }

  Future<void> _loadDarkPref() async {
    await SharedPreferences.getInstance().then((prefs) {
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
    notifyListeners();
  }

  Future<void> _saveDarkPref() async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isDarkTheme', _isDarkTheme);
    });
  }

  get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool newValue) {
    if (newValue == _isDarkTheme) return;
    _isDarkTheme = newValue;
    _saveDarkPref();
    notifyListeners();
  }
}
