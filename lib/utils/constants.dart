import 'package:flutter/material.dart';

// App Colors - Paper & Sketch Aesthetic
class AppColors {
  // Paper Background Colors
  static const backgroundColor = Color(0xFFFFF9F0); // Warm cream
  static const paperLight = Color(0xFFFFFDF8); // Lighter paper
  static const paperMedium = Color(0xFFF5E6D3); // Aged paper
  static const paperDark = Color(0xFFE8D4B8); // Darker aged paper

  // Ink & Text Colors
  static const inkDark = Color(0xFF2B2118); // Deep brown-black ink
  static const inkMedium = Color(0xFF4A4036); // Medium brown
  static const inkLight = Color(0xFF6B5D52); // Light brown
  static const textPrimary = Color(0xFF2B2118); // Primary text
  static const textSecondary = Color(0xFF6B5D52); // Secondary text

  // Watercolor Accent Colors (for moods & highlights)
  static const watercolorPink = Color(0xFFFFB5C5); // Soft pink
  static const watercolorBlue = Color(0xFFB8D4E8); // Soft blue
  static const watercolorYellow = Color(0xFFFFF4B8); // Soft yellow
  static const watercolorGreen = Color(0xFFB8E8C5); // Soft green
  static const watercolorPurple = Color(0xFFD4C5E8); // Soft purple

  // Sketch & Border Colors
  static const sketchBorder = Color(0xFF3D342A); // Dark brown for sketches
  static const sketchLight = Color(0xFF8B7D6B); // Lighter sketch lines

  // Card & Element Colors
  static const cardBackground = Color(0xFFFFFDF8); // Light paper for cards
  static const cardShadow = Color(0x20000000); // Subtle shadow
  static const polaroidBorder = Color(0xFFFFFFFF); // White polaroid border

  // Accent Gradients (subtle watercolor effects)
  static LinearGradient watercolorGradientWarm = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [watercolorPink, watercolorYellow],
  );

  static LinearGradient watercolorGradientCool = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [watercolorBlue, watercolorPurple],
  );

  // Helper colors with alpha values
  static Color inkWithOpacity(double opacity) =>
      inkDark.withValues(alpha: opacity);
  static Color paperDarkWithOpacity(double opacity) =>
      paperDark.withValues(alpha: opacity);
  static Color sketchWithOpacity(double opacity) =>
      sketchBorder.withValues(alpha: opacity);
}

// App Constants
class AppConstants {
  static const String appName = 'Mindry';
  static const String appTagline = 'Your Personal Journal';

  // Gratitude Prompts
  static const List<String> gratitudePrompts = [
    'What made you smile today?',
    'Who are you grateful for?',
    'What\'s something beautiful you noticed today?',
    'What comfort are you thankful for?',
    'What achievement are you proud of today?',
  ];

  // Reflection Questions
  static const List<String> reflectionQuestions = [
    'How are you feeling right now?',
    'What did you learn today?',
    'What challenged you today?',
    'What would you like to improve tomorrow?',
    'What energized you today?',
  ];

  // Database
  static const String journalBoxName = 'journal_entries';
}
