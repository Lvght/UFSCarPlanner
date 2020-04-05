import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  return ThemeData.light().copyWith(
    primaryColor: Colors.red,
    iconTheme: IconThemeData(
      color: Colors.red
    ),
  );
}

ThemeData buildDarkTheme() {
  return ThemeData.dark().copyWith(
  );
}