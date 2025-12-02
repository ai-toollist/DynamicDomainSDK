import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppButtonStyle {
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(
      fontFamily: 'FilsonPro',
      fontSize: 16, fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );

  static ButtonStyle textButton = TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    textStyle: const TextStyle(
      fontFamily: 'FilsonPro',
      fontSize: 14,
    ),
  );
}
