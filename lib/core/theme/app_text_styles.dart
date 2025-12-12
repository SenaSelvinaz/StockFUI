import 'package:flutter/material.dart';
import 'app_colors.dart';

// henüz kullanılmıyor
class AppTextStyles {
  // Başlıklar
  static const TextStyle titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  // Normal metinler
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textMedium,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textLight,
    fontWeight: FontWeight.w400,
  );

  // Çalışan kartı isim yazısı
  static const TextStyle workerName = TextStyle(
    fontSize: 17,
    color: AppColors.textDark,
    fontWeight: FontWeight.w600,
  );

  // Çalışan kartı pozisyon yazısı
  static const TextStyle workerRole = TextStyle(
    fontSize: 14,
    color: AppColors.textLight,
    fontWeight: FontWeight.w400,
  );

  // Buton yazıları
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.buttonText,
  );

  // Sekme (tab bar) yazıları
  static const TextStyle tabTextActive = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle tabTextInactive = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );
}
