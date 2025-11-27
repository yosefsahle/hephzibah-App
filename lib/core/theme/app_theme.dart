import 'package:flutter/material.dart';

class AppTheme {
  // =========================
  // Light ColorScheme
  // =========================
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0F7545), // Forest Green
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFA7DCAA), // Mint Green
    onPrimaryContainer: Color(0xFF0F7545),

    secondary: Color(0xFFA7DCAA), // Mint Green
    onSecondary: Color(0xFF0F7545),
    secondaryContainer: Color(0xFFDFF5E0), // Pale Green
    onSecondaryContainer: Color(0xFF0F7545),

    tertiary: Color(0xFF5F8D4E), // Olive Green
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFA7DCAA),
    onTertiaryContainer: Color(0xFF0F7545),

    background: Color(0xFFF5ECE1), // Soft Cream
    onBackground: Color(0xFF0F7545),
    surface: Color(0xFFF2F2F2), // Light Gray
    onSurface: Color(0xFF0F7545),
    surfaceVariant: Color(0xFFECECEC),
    onSurfaceVariant: Color(0xFF333333),

    error: Color(0xFFE63946), // Red for errors
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFFB00020),

    outline: Color(0xFF777777),
    shadow: Colors.black,
    inverseSurface: Color(0xFF0F7545),
    onInverseSurface: Color(0xFFF5ECE1),
    inversePrimary: Color(0xFFA7DCAA),
    surfaceTint: Color(0xFF0F7545),
  );

  // =========================
  // Dark ColorScheme
  // =========================
  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF0F7545), // Forest Green
    onPrimary: Color(0xFFF5ECE1),
    primaryContainer: Color(0xFF5F8D4E), // Olive accent
    onPrimaryContainer: Color(0xFFF5ECE1),

    secondary: Color(0xFFA7DCAA), // Mint Green
    onSecondary: Color(0xFF121212),
    secondaryContainer: Color(0xFF196E4B), // Dark accent
    onSecondaryContainer: Color(0xFFF5ECE1),

    tertiary: Color(0xFF5F8D4E), // Olive Green
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF0F7545),
    onTertiaryContainer: Color(0xFFFFFFFF),

    background: Color(0xFF121212),
    onBackground: Color(0xFFF5ECE1),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFF5ECE1),
    surfaceVariant: Color(0xFF2C2C2C),
    onSurfaceVariant: Color(0xFFCCCCCC),

    error: Color(0xFFFF5A5F),
    onError: Color(0xFF121212),
    errorContainer: Color(0xFFB00020),
    onErrorContainer: Color(0xFFFFDAD6),

    outline: Color(0xFF888888),
    shadow: Colors.black,
    inverseSurface: Color(0xFFF5ECE1),
    onInverseSurface: Color(0xFF121212),
    inversePrimary: Color(0xFFA7DCAA),
    surfaceTint: Color(0xFF0F7545),
  );

  // =========================
  // ThemeData Getter
  // =========================
  static ThemeData getTheme({required Brightness brightness, Locale? locale}) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = isDark ? darkColorScheme : lightColorScheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          // H1
          fontSize: 68, // 16 * 1.618^3
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          // H2
          fontSize: 42, // 16 * 1.618^2
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          // H3
          fontSize: 26, // 16 * 1.618^1
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          fontSize: 16, // Base
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          fontSize: 13, // 16 / 1.618
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          fontSize: 10, // 16 / (1.618²)
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontSize: 16, // Base reading size
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary),
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.primaryContainer,
        contentTextStyle: TextStyle(color: colorScheme.onPrimaryContainer),
        behavior: SnackBarBehavior.floating,
      ),

      // ListTile Theme
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.surface,
        iconColor: colorScheme.primary,
        textColor: colorScheme.onSurface,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(color: colorScheme.outline, thickness: 1),
    );
  }
}
