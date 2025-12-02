import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand palette
const kPrimary     = Color(0xFF284B63);
const kSecondary   = Color(0xFF8EADC3);
const kPrimaryDark = Color(0xFF1A2F3D);
const kAccent      = Color(0xFFD9D9D9);
const kBackground  = Color(0xFFF8F9FA);
const kHighlight   = Color(0xFFFFFFFF);
const kWarn        = Color(0xFFFF8C42);
const kStar        = Color(0xFFFFC107);
const kTextDark    = Color(0xFF1E1E1E);

const kCardRadius = 18.0;
const kPillRadius = 24.0;

final kCardShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.04),
    offset: const Offset(0, 4),
    blurRadius: 12,
    spreadRadius: 0,
  ),
  BoxShadow(
    color: Colors.black.withOpacity(0.02),
    offset: const Offset(0, 2),
    blurRadius: 6,
    spreadRadius: 0,
  ),
];

ThemeData buildBitefulTheme({
  required TextStyle amiko,
  required TextStyle mogra,
  required TextStyle inter,
}) {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: kBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimary,
      primary: kPrimary,
      onPrimary: kHighlight,
      secondary: kSecondary,
      onSecondary: kHighlight,
      surface: kHighlight,
      onSurface: kTextDark,
      brightness: Brightness.light,
    ),
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: kTextDark,
      displayColor: kTextDark,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: kTextDark,
      centerTitle: false,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: kTextDark,
        letterSpacing: -0.3,
      ),
      iconTheme: const IconThemeData(color: kTextDark, size: 24),
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),

    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: kTextDark,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 15,
        color: Colors.grey.shade600,
        height: 1.4,
      ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),

    cardTheme: CardThemeData(
      color: kHighlight,
      elevation: 0,
      margin: EdgeInsets.zero,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kHighlight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(color: Colors.grey.shade500),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: kAccent.withOpacity(0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: kPrimary, width: 2),
      ),
    ),

    // Premium buttons
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.4,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 0,
        shadowColor: kPrimary.withOpacity(0.3),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return kPrimaryDark.withOpacity(0.15);
          }
          if (states.contains(WidgetState.hovered)) {
            return kPrimary.withOpacity(0.08);
          }
          return null;
        }),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kPrimary,
        side: BorderSide(color: kPrimary.withOpacity(0.4), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.4,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),

    dividerTheme: DividerThemeData(
      color: kAccent.withValues(alpha: 0.5),
    ),
  );
}
