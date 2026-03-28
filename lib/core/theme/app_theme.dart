import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Refined Color Palette
  static const Color primaryColor = Color(0xFF6366F1); // Indigo modern
  static const Color secondaryColor = Color(0xFF1E293B); // Slate
  static const Color accentColor = Color(0xFFF43F5E); // Rose for CTAs
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B);

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        tertiary: accentColor,
        surface: backgroundLight,
        onSurface: secondaryColor,
        onSurfaceVariant: const Color(0xFF64748B), // Slate-500
        outlineVariant: const Color(0xFFE2E8F0), // Slate-200
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: secondaryColor),
        displayMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: secondaryColor),
        titleLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: secondaryColor),
        bodyLarge: GoogleFonts.inter(color: secondaryColor.withValues(alpha: 0.9), fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFF64748B)),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: secondaryColor),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: secondaryColor,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: Colors.white,
        onSecondary: secondaryColor,
        surface: backgroundDark,
        onSurface: Colors.white,
        onSurfaceVariant: const Color(0xFF94A3B8), // Slate-400
        outlineVariant: const Color(0xFF334155), // Slate-700
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: Colors.white),
        displayMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white),
        titleLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.9), fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
      ),
    );
  }
}
