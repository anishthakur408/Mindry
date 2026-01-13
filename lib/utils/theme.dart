import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryColor: AppColors.inkDark,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.inkDark,
        secondary: AppColors.watercolorPink,
        surface: AppColors.cardBackground,
        surfaceContainerHighest: AppColors.paperMedium,
        onPrimary: AppColors.paperLight,
        onSecondary: AppColors.inkDark,
        onSurface: AppColors.inkDark,
      ),

      // Text Theme - Mix of handwriting and clean fonts
      textTheme: TextTheme(
        // Headers - Handwritten style
        displayLarge: GoogleFonts.indieFlower(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.indieFlower(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.indieFlower(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        // Body text - Clean and readable
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.indieFlower(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.inkDark,
        ),
      ),

      // Floating Action Button Theme - Sketch style
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.watercolorPink,
        foregroundColor: AppColors.inkDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.sketchBorder,
            width: 2,
          ),
        ),
      ),

      // Card Theme - Polaroid style
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 3,
        shadowColor: AppColors.cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(
            color: AppColors.sketchLight,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),

      // Input Decoration Theme - Ruled paper style
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paperLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.sketchBorder,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.sketchLight,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.sketchBorder,
            width: 2,
          ),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Elevated Button Theme - Sketch style button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.watercolorYellow,
          foregroundColor: AppColors.inkDark,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: AppColors.sketchBorder,
              width: 2,
            ),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.inkDark,
        size: 24,
      ),

      // Divider Theme - Sketch line
      dividerTheme: const DividerThemeData(
        color: AppColors.sketchLight,
        thickness: 1,
        space: 24,
      ),
    );
  }

  // Keep darkTheme for backwards compatibility, but point to lightTheme
  static ThemeData get darkTheme => lightTheme;
}
