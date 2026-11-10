import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF00A68A);
  static const darkBackground = Color(0xFF0F1F17);
  static const darkGreen = Color(0xFF1E3A2E);
  static const green = Color(0xFF3E5A3F);
  static const mutedGreen = Color(0xFF6B7F67);
  static const light = Color(0xFFC7CBB8);
  static const greyGreen = Color(0xFF3D4337);

  static const white = Color(0xFFFFFFFF);
  static const background = Color(0xFFF5F7F5);
  static const text = Color(0xFF17231D);
  static const grey = Color(0xFF78847E);
  static const border = Color(0xFFE1E8E3);
  static const red = Color(0xFFE45757);
  static const orange = Color(0xFFE9A23B);
  static const blue = Color(0xFF4787D7);
}

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
    fontFamily: 'Arial',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.text,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
    ),
  );
}