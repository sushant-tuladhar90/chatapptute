import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface:  Colors.white,  //for whole Scaffold
    primary: const Color.fromARGB(255, 241, 241, 246),  // for textfields only & in highlighted area
    secondary: const Color.fromARGB(255, 243, 243, 243),
    tertiary: const Color(0xff0F1828),  //only for text or images used
    inversePrimary: Colors.grey.shade900,
  ),
  textTheme: GoogleFonts.mulishTextTheme(),
);