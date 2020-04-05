import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  return ThemeData.light().copyWith(
    primaryColor: Colors.red,
    accentColor: Colors.redAccent,
    iconTheme: IconThemeData(
      color: Colors.redAccent,
    ),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData.dark().copyWith(
    primaryColor: Color(0xFF771515),
    accentColor: Color(0xFF994444),
    iconTheme: IconThemeData(
      color: Color(0xFF994444)
    ),
  );
}