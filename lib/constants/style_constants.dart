// lib/constants/style_constants.dart

import 'package:flutter/material.dart';

class StyleConstants {
  // Colors
  static const Color primaryColor = Color(0xFFCE7D66);
  static const Color backgroundColor = Colors.white;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.grey;
  static const Color cardBackground = Colors.white;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFCE7D66), Color(0xFFE9967A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFBB8475), Color(0xFFAA7265)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Spacing
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double borderRadius = 12.0;
  static const double smallSpacing = 8.0;
  static const double largeSpacing = 24.0;

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: textSecondary,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textPrimary,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: textSecondary,
  );

  // Card Decorations
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [defaultShadow],
  );

  static BoxDecoration gradientCardDecoration = BoxDecoration(
    gradient: cardGradient,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [defaultShadow],
  );

  // Input Decorations
  static InputDecoration searchInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.grey[100],
    hintStyle: subtitleStyle,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: defaultPadding,
      vertical: defaultPadding / 2,
    ),
  );

  // Button Styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: defaultPadding * 2,
      vertical: defaultPadding,
    ),
  );

  static ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: const BorderSide(color: primaryColor),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: defaultPadding * 2,
      vertical: defaultPadding,
    ),
  );

  // Common Shadow
  static BoxShadow defaultShadow = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 4,
    offset: const Offset(0, 2),
  );

  // App Bar Theme
  static AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: backgroundColor,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: textPrimary),
    titleTextStyle: titleStyle,
  );

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData bottomNavTheme =
      BottomNavigationBarThemeData(
    backgroundColor: backgroundColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: textSecondary,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: captionStyle.copyWith(fontWeight: FontWeight.w500),
    unselectedLabelStyle: captionStyle,
  );

  // Tab Bar Theme
  static TabBarTheme tabBarTheme = TabBarTheme(
    labelColor: backgroundColor,
    unselectedLabelColor: textSecondary,
    indicator: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(30),
    ),
    labelStyle: bodyStyle.copyWith(fontWeight: FontWeight.w500),
    unselectedLabelStyle: bodyStyle,
  );

  // Card Shape
  static RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );
}
