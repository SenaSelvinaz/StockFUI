import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

// henüz kullanılmıyor
class AppButtons {
  /// **Primary Button** – ana renkli büyük buton
  static Widget primary({
    required String text,
    required VoidCallback onTap,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    double borderRadius = 12,
    IconData? icon,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 9, 86, 202),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(text, style: AppTextStyles.buttonText),
            ],
          ),
        ),
      ),
    );
  }
  static Widget secondary({
    required String text,
    required VoidCallback onTap,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    double borderRadius = 12,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.tabInactive,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: padding,
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// **Outline Button** – çerçeveli buton
  static Widget outline({
    required String text,
    required VoidCallback onTap,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    double borderRadius = 12,
    Color borderColor = const Color.fromARGB(255, 79, 172, 143),
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1.3),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: padding,
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: borderColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
