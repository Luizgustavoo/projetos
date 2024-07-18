import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardTheme(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)))),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(10)))),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Color(0xFF1d1d1d),
      backgroundColor: Color(0xFF1d1d1d),
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFE8E3E3),
      labelStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.black54),
      border: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
    ),
    useMaterial3: true,
    colorSchemeSeed: Colors.orange);
