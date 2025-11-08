import 'package:flutter/material.dart';

// Global App Theme Colors
const Color burntOrange = Color(0xFFCC5500);
const Color lightBackground = Color(0xFFFDFDFD);

ThemeData appTheme = ThemeData(
  primaryColor: burntOrange,
  scaffoldBackgroundColor: lightBackground,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: burntOrange,
    foregroundColor: Colors.white,
  ),
);
