import 'package:chatapptute/theme/dart_mode.dart';
import 'package:chatapptute/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData (ThemeData themeData){
    _themeData = themeData.copyWith(
      textTheme: GoogleFonts.mulishTextTheme(),);
    notifyListeners();
  }

  void toggleTheme () {
    if (themeData == lightMode) {
      themeData = darkMode;
    }
    else {
      themeData = lightMode;
    }
  }
}