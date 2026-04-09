import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Dark Mode ---
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color foregroundDark = Color(0xFFEDEDED);
  static const Color cardDark = Color(0xFF111111);
  static const Color primaryDark = Color(0xFF6366F1);
  static const Color secondaryDark = Color(0xFF27272A);
  static const Color mutedDark = Color(0xFF27272A);
  static const Color mutedForegroundDark = Color(0xFFA1A1AA);
  static const Color borderDark = Color(0xFF27272A);
  static const Color sidebarDark = Color(0xFF09090B);

  // --- Light Mode ---
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color foregroundLight = Color(0xFF09090B);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color primaryLight = Color(0xFF4F46E5);
  static const Color secondaryLight = Color(0xFFF4F4F5);
  static const Color mutedLight = Color(0xFFF4F4F5);
  static const Color mutedForegroundLight = Color(0xFF52525B);
  static const Color borderLight = Color(0xFFE4E4E7);
  static const Color sidebarLight = Color(0xFFFAFAFA);

  static const Color destructive = Color(0xFFEF4444);

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.light(
        surface: backgroundLight,
        onSurface: foregroundLight,
        primary: primaryLight,
        onPrimary: Colors.white,
        secondary: secondaryLight,
        onSecondary: foregroundLight,
        error: destructive,
        outline: borderLight,
        surfaceContainerHighest: mutedLight,
        onSurfaceVariant: mutedForegroundLight,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: foregroundLight,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          color: foregroundLight,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          color: foregroundLight,
        ),
        bodyLarge: GoogleFonts.inter(
          color: foregroundLight.withValues(alpha: 0.9),
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(color: mutedForegroundLight),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: foregroundLight),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: foregroundLight,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: borderLight),
        ),
      ),
      extensions: [
        AppEffects(
          glassColor: Colors.white.withValues(alpha: 0.9),
          glassBlur: 12.0,
          textGradient: const LinearGradient(
            colors: [Color(0xFF818CF8), Color(0xFFC084FC)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          heroGradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        surface: backgroundDark,
        onSurface: foregroundDark,
        primary: primaryDark,
        onPrimary: Colors.white,
        secondary: secondaryDark,
        onSecondary: foregroundDark,
        error: destructive,
        outline: borderDark,
        surfaceContainerHighest: mutedDark,
        onSurfaceVariant: mutedForegroundDark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800,
          color: foregroundDark,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          color: foregroundDark,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
          color: foregroundDark,
        ),
        bodyLarge: GoogleFonts.inter(
          color: foregroundDark.withValues(alpha: 0.9),
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(color: mutedForegroundDark),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: foregroundDark),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: foregroundDark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: borderDark),
        ),
      ),
      extensions: [
        AppEffects(
          glassColor: Colors.white.withValues(alpha: 0.03),
          glassBlur: 12.0,
          textGradient: const LinearGradient(
            colors: [Color(0xFF818CF8), Color(0xFFC084FC)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          heroGradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ],
    );
  }
}

class AppEffects extends ThemeExtension<AppEffects> {
  final Color glassColor;
  final double glassBlur;
  final Gradient textGradient;
  final Gradient heroGradient;

  AppEffects({
    required this.glassColor,
    required this.glassBlur,
    required this.textGradient,
    required this.heroGradient,
  });

  @override
  AppEffects copyWith({
    Color? glassColor,
    double? glassBlur,
    Gradient? textGradient,
    Gradient? heroGradient,
  }) {
    return AppEffects(
      glassColor: glassColor ?? this.glassColor,
      glassBlur: glassBlur ?? this.glassBlur,
      textGradient: textGradient ?? this.textGradient,
      heroGradient: heroGradient ?? this.heroGradient,
    );
  }

  @override
  AppEffects lerp(ThemeExtension<AppEffects>? other, double t) {
    if (other is! AppEffects) return this;
    return AppEffects(
      glassColor: Color.lerp(glassColor, other.glassColor, t)!,
      glassBlur: glassBlur + (other.glassBlur - glassBlur) * t,
      textGradient: Gradient.lerp(textGradient, other.textGradient, t)!,
      heroGradient: Gradient.lerp(heroGradient, other.heroGradient, t)!,
    );
  }
}
