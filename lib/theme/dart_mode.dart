import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: const Color(0xff0F1828), //for whole Scaffold
    primary: const Color(0xff1B2B48), // for textfields only & in highlighted area
    secondary: const Color.fromARGB(255, 0, 0, 0), 
    tertiary:  const Color(0xffF7F7FC), //only for text or images used
    inversePrimary: Colors.grey.shade300,
  ),
  textTheme: GoogleFonts.mulishTextTheme(),
);