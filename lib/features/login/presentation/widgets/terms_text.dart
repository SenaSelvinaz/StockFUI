import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flinder_app/core/constants/app_colors.dart';
import 'package:flinder_app/core/constants/app_strings.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                height: 1.5,
              ),
          children: [
            TextSpan(
              text: AppStrings.termsPrefix,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: AppStrings.termsLink,
              style: const TextStyle(
                color: AppColors.link,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Kullanım Koşulları sayfasına git
                  print('Kullanım Koşulları tıklandı');
                },
            ),
            TextSpan(
              text: AppStrings.termsMiddle,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: AppStrings.privacyLink,
              style: const TextStyle(
                color: AppColors.link,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Gizlilik Politikası sayfasına git
                  print('Gizlilik Politikası tıklandı');
                },
            ),
            TextSpan(
              text: AppStrings.termsSuffix,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
