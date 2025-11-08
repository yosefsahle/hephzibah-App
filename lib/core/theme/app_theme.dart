import 'package:flutter/material.dart';
import 'color_scheme.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData getTheme({
    required Locale locale,
    required Brightness brightness,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final bool isAmharic = locale.languageCode == 'am';

    final String fontFamily = isAmharic ? 'NotoSansEthiopic' : 'Poppins';

    final Color primaryText = isDark
        ? AppColors.darkPrimaryText
        : AppColors.lightPrimaryText;
    final Color secondaryText = isDark
        ? AppColors.darkSecondaryText
        : AppColors.lightSecondaryText;

    return ThemeData(
      brightness: brightness,
      fontFamily: fontFamily,
      iconTheme: IconThemeData(
        color: isDark
            ? AppColors.darkSecondaryAccent
            : AppColors.lightSecondaryAccent,
      ),
      scaffoldBackgroundColor: isDark
          ? AppColors.darkPrimaryBackground
          : AppColors.lightPrimaryBackground,
      primaryColor: AppColors.lightPrimaryAccent,
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: primaryText,
          fontFamily: fontFamily,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: primaryText,
          fontFamily: fontFamily,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: secondaryText,
          fontFamily: fontFamily,
        ),
        // Continue for other styles...
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? AppColors.darkPrimaryBackground
            : AppColors.lightPrimaryBackground,
        foregroundColor: primaryText,
        elevation: 0,
      ),
    );
  }
}
