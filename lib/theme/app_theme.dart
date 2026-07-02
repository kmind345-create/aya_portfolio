import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Aya's Graphique — design tokens.
/// A monochrome-purple palette, every tone pulled from (or mixed between)
/// the brand portrait's own colors: the deep aubergine background, the
/// mid violet of the clothing, and a brighter electric-orchid grade added
/// purely as a tint between those two — no red, orange, or gold anywhere.
/// Dark, moody, gallery-like canvas so the illustration + logo work pops.
class AppColors {
  AppColors._();

  static const Color bgDeep = Color(0xFF0D0512); // near-black, deeper purple-black background
  static const Color bgPurple = Color(0xFF3A1750); // darker brand purple (from artwork bg, deepened)
  static const Color surface = Color(0xFF1E0F2A); // card / section surface, deepened
  static const Color surfaceRaised = Color(0xFF2E1740); // deepened
  static const Color ink = Color(0xFF1A0B26); // extra-deep dark purple, near-black ink

  static const Color violetDeep = Color(0xFF2C1240); // deepest accent grade, darkened
  static const Color violetMid = Color(0xFF5C3578); // clothing mid-tone, richer & darker
  static const Color violetLight = Color(0xFF8B6BAE); // clothing highlight
  static const Color violetPop = Color(0xFF9B3FD1); // bright electric grade, pushed darker/more saturated
  static const Color orchid = Color(0xFFC183EE); // light lilac accent, kept vivid
  static const Color orchidSoft = Color(0xFFE7D4F5); // near-white lilac

  static const Color cream = Color(0xFFF6EFFB); // near-white, lilac-tinted
  static const Color creamDim = Color(0xFFC2AED4);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgDeep, ink, bgPurple, surfaceRaised],
    stops: [0.0, 0.32, 0.68, 1.0],
  );

  /// The single signature accent gradient — every shade is a purple grade,
  /// running from the deep brand violet up to the light lilac highlight.
  static const LinearGradient violetGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [violetDeep, violetPop, orchid],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient violetGradientWide = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ink, violetDeep, violetMid, violetPop, orchid],
    stops: [0.0, 0.3, 0.55, 0.8, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceRaised, surface, ink],
    stops: [0.0, 0.55, 1.0],
  );
}

class AppFonts {
  AppFonts._();

  /// Characterful geometric display face — used sparingly for headlines.
  static TextStyle display({
    double size = 64,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.cream,
    double? height,
    double? letterSpacing,
  }) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing ?? -1.0,
      );

  /// Clean, warm body face for readable copy.
  static TextStyle body({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.creamDim,
    double? height,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height ?? 1.6,
      );

  /// Wide-tracked mono-ish utility face for eyebrows / labels / nav.
  static TextStyle label({
    double size = 13,
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.orchid,
    double letterSpacing = 3.0,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );
}

class AppBreakpoints {
  AppBreakpoints._();
  static const double mobile = 700;
  static const double tablet = 1050;
  static const double desktop = 1400;

  static bool isMobile(double w) => w < mobile;
  static bool isTablet(double w) => w >= mobile && w < tablet;
  static bool isDesktop(double w) => w >= tablet;
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bgDeep,
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.violetPop,
      secondary: AppColors.orchid,
      surface: AppColors.surface,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
}
