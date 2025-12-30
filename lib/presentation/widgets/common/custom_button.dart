import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';

enum ButtonType { primary, secondary, outline, text }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color?  textColor;

  const CustomButton({
    super.key,
    required this. text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this. isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(),
    );
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return 50;
      case ButtonSize.large:
        return 56;
    }
  }

  Widget _buildButton() {
    final child = isLoading
        ? SizedBox(
            height: 20,
            width:  20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.outline ?  AppColors.primary900 : AppColors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primary900,
            foregroundColor: textColor ?? AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            textStyle: _getTextStyle(),
          ),
          child: child,
        );
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.accent400,
            foregroundColor: textColor ?? AppColors.primary900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius. circular(AppConstants.radiusMd),
            ),
            textStyle: _getTextStyle(),
          ),
          child: child,
        );
      case ButtonType.outline:
        return OutlinedButton(
          onPressed:  isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppColors.primary900,
            side: BorderSide(color: backgroundColor ?? AppColors.primary900, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius. circular(AppConstants.radiusMd),
            ),
            textStyle: _getTextStyle(),
          ),
          child: child,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ??  AppColors.secondary500,
            textStyle: _getTextStyle(),
          ),
          child: child,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize. small:
        return AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600);
      case ButtonSize.medium:
        return AppTypography.buttonMedium;
      case ButtonSize.large:
        return AppTypography.buttonLarge;
    }
  }
}