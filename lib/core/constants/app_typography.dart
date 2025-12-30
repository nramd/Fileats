import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String fontFamily = 'Gabarito';

  // Scale 1.25 - Base 12px
  static const double fontSizeXxs = 8.0;   
  static const double fontSizeXs = 10.0;   
  static const double fontSizeSm = 12.0;   
  static const double fontSizeMd = 15.0;   
  static const double fontSizeLg = 19.0;   
  static const double fontSizeXl = 23.0;   
  static const double fontSize2xl = 29.0;  
  static const double fontSize3xl = 37.0;  
  static const double fontSize4xl = 46.0;  
  static const double fontSize5xl = 57.0;  
  static const double fontSize6xl = 72.0;  

  // Heading Styles
  static TextStyle heading1 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize6xl,
    fontWeight: FontWeight.w700,
    color: AppColors. primary900,
    height: 1.2,
  );

  static TextStyle heading2 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize5xl,
    fontWeight: FontWeight.w700,
    color: AppColors. primary900,
    height: 1.2,
  );

  static TextStyle heading3 = const TextStyle(
    fontFamily: fontFamily,
    fontSize:  fontSize4xl,
    fontWeight: FontWeight.w600,
    color: AppColors. primary900,
    height: 1.3,
  );

  static TextStyle heading4 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize3xl,
    fontWeight: FontWeight.w600,
    color: AppColors.primary900,
    height: 1.3,
  );

  static TextStyle heading5 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize2xl,
    fontWeight: FontWeight.w600,
    color: AppColors.primary900,
    height: 1.4,
  );

  static TextStyle heading6 = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXl,
    fontWeight:  FontWeight.w600,
    color: AppColors.primary900,
    height: 1.4,
  );

  // Body Styles
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeLg,
    fontWeight: FontWeight.w400,
    color: AppColors.grey800,
    height: 1.5,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontFamily:  fontFamily,
    fontSize: fontSizeMd,
    fontWeight: FontWeight.w400,
    color: AppColors.grey800,
    height: 1.5,
  );

  static TextStyle bodySmall = const TextStyle(
    fontFamily:  fontFamily,
    fontSize: fontSizeSm,
    fontWeight:  FontWeight.w400,
    color: AppColors.grey600,
    height: 1.5,
  );

  // Label Styles
  static TextStyle labelLarge = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeMd,
    fontWeight: FontWeight.w600,
    color: AppColors.grey800,
    height: 1.4,
  );

  static TextStyle labelMedium = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: FontWeight.w500,
    color: AppColors. grey700,
    height: 1.4,
  );

  static TextStyle labelSmall = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight:  FontWeight.w500,
    color: AppColors.grey600,
    height: 1.4,
  );

  // Button Text
  static TextStyle buttonLarge = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeLg,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  static TextStyle buttonMedium = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeMd,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  // Caption
  static TextStyle caption = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight:  FontWeight.w400,
    color: AppColors. grey500,
    height: 1.4,
  );
}