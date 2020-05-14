/*
* Inicialmente creada para colores, pero se podría incluir tipos de letra tamaños, etc
*/
import 'dart:ui' show Color; // Basada en la clase Colors

import 'package:flutter/material.dart';

class Style {
  Style._();
  // Para generar el codigo de colores: http://mcg.mbitson.com/#!?primary=%232c3e50
  //* Secondary Color
  static const MaterialColor secondary = MaterialColor(_secondaryPrimaryValue, <int, Color>{
    50: Color(0xFFFEF3E3),
    100: Color(0xFFFBE1B8),
    200: Color(0xFFF9CE89),
    300: Color(0xFFF7BA59),
    400: Color(0xFFF5AB36),
    500: Color(_secondaryPrimaryValue),
    600: Color(0xFFF19410),
    700: Color(0xFFEF8A0D),
    800: Color(0xFFED800A),
    900: Color(0xFFEA6E05),
  });
  static const int _secondaryPrimaryValue = 0xFFF39C12;

  static const MaterialColor secondaryAccent = MaterialColor(_secondaryAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_secondaryAccentValue),
    400: Color(0xFFFFCEAC),
    700: Color(0xFFFFBF92),
  });
  static const int _secondaryAccentValue = 0xFFFFECDF;

  //* Prrimary Color
  static const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
    50: Color(0xFFE3E4E5),
    100: Color(0xFFB9BBBF),
    200: Color(0xFF8A8D94),
    300: Color(0xFF5B5F69),
    400: Color(0xFF383D49),
    500: Color(_primaryPrimaryValue),
    600: Color(0xFF121824),
    700: Color(0xFF0F141F),
    800: Color(0xFF0C1019),
    900: Color(0xFF06080F),
  });
  static const int _primaryPrimaryValue = 0xFF151B29;

  static const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
    100: Color(0xFF5370FF),
    200: Color(_primaryAccentValue),
    400: Color(0xFF0028EC),
    700: Color(0xFF0024D2),
  });
  static const int _primaryAccentValue = 0xFF2046FF;
}