import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/core.dart';

class ThemeNotifier with ChangeNotifier {
  static const String key = 'theme';

  late SharedPreferences prefs;
  late bool _darkTheme;
  ThemeData currentTheme = kDarkTHEME;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = false;
    _loadFromPrefs();
  }

  void toggleTheme() {
    if (_darkTheme) {
      currentTheme = kTHEME;
    } else {
      currentTheme = kDarkTHEME;
    }
    _darkTheme = !_darkTheme;
    _saveTPrefs();
    notifyListeners();
  }

  void _loadFromPrefs() async {
    await initPrefs();

    String? tempTheme = prefs.getString(key);

    if (tempTheme == 'dark') {
      currentTheme = kDarkTHEME;
      _darkTheme = true;
    } else {
      _darkTheme = false;
      currentTheme = kTHEME;
    }

    notifyListeners();
  }

  void _saveTPrefs() async {
    await initPrefs();
    if (_darkTheme) {
      await prefs.setString(key, 'dark');
    } else {
      await prefs.setString(key, 'light');
    }
  }

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
}
