import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final arabic = GoogleFonts.cairoTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.creamBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.kaveaOrange,
        onPrimary: Color(0xFFFBF6EC),
        secondary: AppColors.stripeBlue,
        onSecondary: AppColors.darkCoffee,
        surface: AppColors.cardSurface,
        onSurface: AppColors.darkCoffee,
        tertiary: AppColors.leather,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.darkCoffee),
        titleTextStyle: GoogleFonts.specialElite(
          fontSize: 20,
          color: AppColors.darkCoffee,
          letterSpacing: 2,
        ),
      ),
      textTheme: arabic.copyWith(
        displayLarge: GoogleFonts.caveat(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: AppColors.paperInk,
          height: 0.9,
        ),
        displayMedium: GoogleFonts.caveat(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.kaveaOrange,
        ),
        titleLarge: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.darkCoffee,
        ),
        titleMedium: GoogleFonts.specialElite(
          fontSize: 15,
          color: AppColors.darkCoffee,
          letterSpacing: 1.4,
        ),
        bodyLarge: GoogleFonts.cairo(
          fontSize: 16,
          color: AppColors.darkCoffee,
        ),
        bodyMedium: GoogleFonts.cairo(
          fontSize: 14,
          color: AppColors.coffeeLight,
        ),
        labelLarge: GoogleFonts.specialElite(
          fontSize: 13,
          letterSpacing: 1.6,
          color: AppColors.paperInk,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.warmCream,
        selectedColor: AppColors.kaveaOrange,
        secondarySelectedColor: AppColors.kaveaOrange,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: GoogleFonts.specialElite(
          fontSize: 12,
          letterSpacing: 1.2,
          color: AppColors.darkCoffee,
        ),
        secondaryLabelStyle: GoogleFonts.specialElite(
          fontSize: 12,
          letterSpacing: 1.2,
          color: AppColors.paperInk,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppColors.kaveaOrange, width: 1.4),
        ),
      ),
    );
  }
}
