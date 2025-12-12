import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Système de thème complet pour EasyTravel Tunisie
class AppTheme {
  // ====================================================================
  // PALETTE DE COULEURS
  // ====================================================================
  static const Color primary = Color(0xFFFF385C);
  static const Color primaryHover = Color(0xFFE31C5F);
  static const Color primaryLight = Color(0xFFFF6B6B);
  static const Color primaryDark = Color(0xFFD91C4F);

  static const Color secondary = Color(0xFF222222);
  static const Color accent = Color(0xFF4285F4);
  static const Color accentLight = Color(0xFF667eea);
  static const Color accentDark = Color(0xFF764ba2);

  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);

  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF717171);
  static const Color textTertiary = Color(0xFFA0A0A0);
  static const Color textLight = Color(0xFFFFFFFF);

  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundAlt = Color(0xFFF7F7F7);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color backgroundCard = Color(0xFFFAFAFA);
  static const Color background = Color(0xFFF8F9FF);
  static const Color border = Color(0xFFDDDDDD);
  static const Color borderLight = Color(0xFFEBEBEB);
  static const Color borderDark = Color(0xFF404040);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentLight, accentDark],
  );

  static const LinearGradient promoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient luxuryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
  );

  // ====================================================================
  // DIMENSIONS ET ESPACEMENTS
  // ====================================================================
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 12.0;
  static const double paddingLG = 16.0;
  static const double paddingXL = 20.0;
  static const double paddingXXL = 24.0;
  static const double paddingXXXL = 32.0;

  static const double marginXS = 4.0;
  static const double marginSM = 8.0;
  static const double marginMD = 12.0;
  static const double marginLG = 16.0;
  static const double marginXL = 20.0;
  static const double marginXXL = 24.0;
  static const double marginXXXL = 32.0;

  static const double radiusXS = 8.0;
  static const double radiusSM = 12.0;
  static const double radiusMD = 16.0;
  static const double radiusLG = 24.0;
  static const double radiusXL = 32.0;
  static const double radiusCircle = 999.0;

  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 12.0;
  static const double elevationXXL = 16.0;

  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 40.0;
  static const double iconXXL = 48.0;

  static const double buttonHeightSM = 36.0;
  static const double buttonHeightMD = 44.0;
  static const double buttonHeightLG = 52.0;
  static const double buttonHeightXL = 60.0;

  static const double imageHeightSM = 200.0;
  static const double imageHeightMD = 260.0;
  static const double imageHeightLG = 320.0;
  static const double imageHeightXL = 400.0;

  // ====================================================================
  // STYLES DE TEXTE
  // ====================================================================
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: textPrimary,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      color: textPrimary,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: textPrimary,
      height: 1.3,
      letterSpacing: -0.3,
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: textPrimary,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: textPrimary,
      height: 1.3,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: textPrimary,
      height: 1.4,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: textPrimary,
      height: 1.3,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: textPrimary,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textPrimary,
      height: 1.4,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: textPrimary,
      height: 1.6,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textSecondary,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: textTertiary,
      height: 1.5,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textPrimary,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: textSecondary,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: textTertiary,
      height: 1.4,
      letterSpacing: 0.5,
    ),
  );
  // Ombres
static const List<BoxShadow> shadowLight = [
  BoxShadow(
    color: Colors.black12,
    blurRadius: 10,
    offset: Offset(0, 5),
  ),
];

static const List<BoxShadow> shadowCard = [
  BoxShadow(
    color: Colors.black26,
    blurRadius: 12,
    offset: Offset(0, 6),
  ),
];

  // ====================================================================
  // THEME CLAIR
  // ====================================================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundLight,
      cardColor: backgroundCard,
      dividerColor: borderLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accent,
        tertiary: accentLight,
        surface: backgroundLight,
        error: error,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textPrimary,
        onError: textLight,
        outline: border,
        surfaceContainerHighest: backgroundAlt,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: backgroundLight,
        foregroundColor: textPrimary,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          height: 1.2,
        ),
      ),
    );
  }

  // ====================================================================
  // THEME SOMBRE
  // ====================================================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundDark,
      cardColor: const Color(0xFF2D2D2D),
      dividerColor: borderDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        tertiary: accentLight,
        surface: backgroundDark,
        error: error,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textLight,
        onError: textLight,
        outline: borderDark,
        surfaceContainerHighest: Color(0xFF2D2D2D),
      ),
      textTheme: textTheme.apply(bodyColor: textLight, displayColor: textLight),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: backgroundDark,
        foregroundColor: textLight,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}
