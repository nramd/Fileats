import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme:  const ColorScheme. light(
        primary: AppColors.primary900,
        onPrimary: AppColors.white,
        secondary: AppColors.secondary500,
        onSecondary: AppColors.white,
        tertiary: AppColors.accent400,
        onTertiary:  AppColors.primary900,
        surface: AppColors.surface,
        onSurface: AppColors.grey900,
        error: AppColors.error,
        onError: AppColors.white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppColors.background,
      
      // AppBar
      appBarTheme:  AppBarTheme(
        backgroundColor:  AppColors.white,
        foregroundColor: AppColors.primary900,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.heading6,
        iconTheme: const IconThemeData(color: AppColors.primary900),
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shadowColor: AppColors.grey300,
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary900,
          foregroundColor: AppColors. white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(AppConstants. radiusMd),
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary900,
          side: const BorderSide(color: AppColors.primary900, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical:  AppConstants.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          textStyle: AppTypography.buttonMedium. copyWith(
            color: AppColors.primary900,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.secondary500,
          textStyle: AppTypography.labelLarge,
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants. spacingMd,
          vertical: AppConstants.spacingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: BorderSide. none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color:  AppColors.primary900, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey400),
        labelStyle: AppTypography.labelMedium,
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary900,
        unselectedItemColor: AppColors. grey400,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent400,
        foregroundColor:  AppColors.primary900,
      ),
      
      // Divider
      dividerTheme:  const DividerThemeData(
        color: AppColors.grey200,
        thickness: 1,
        space: 1,
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor:  AppColors.grey100,
        selectedColor: AppColors.primary900,
        labelStyle: AppTypography.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants. spacingSm,
          vertical: AppConstants.spacingXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(AppConstants. radiusFull),
        ),
      ),
    );
  }
}