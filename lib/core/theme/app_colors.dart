import 'package:flutter/material.dart';

class AppColors {
  // ── Brand Primary & Secondary Colors ─────────────────────────────
  static const Color primary = Color(0xFF004AC6);
  static const Color primaryContainer = Color(0xFF2563EB);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFEEEFFF);

  static const Color secondary = Color(0xFF00687A);
  static const Color secondaryContainer = Color(0xFF0891B2);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF006172);

  static const Color tertiary = Color(0xFF006056);
  static const Color tertiaryContainer = Color(0xFF007B6E);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // ── Light Theme Foundation Palette ─────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);
  static const Color onBackground = Color(0xFF0F172A);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF0F172A);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color onSurfaceVariant = Color(0xFF475569);

  static const Color outline = Color(0xFFCBD5E1);
  static const Color outlineVariant = Color(0xFFE2E8F0);

  // ── Dark Theme Foundation Palette ──────────────────────────────────
  static const Color darkBackground = Color(0xFF090D16);
  static const Color darkSurface = Color(0xFF132238);
  static const Color darkOnSurface = Color(0xFFF8FAFC);
  static const Color darkSurfaceVariant = Color(0xFF1E293B);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  static const Color darkOutline = Color(0xFF334155);

  // ── Semantic & Status Colors ──────────────────────────────────────
  static const Color error = Color(0xFFDC2626);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color lostBadge = Color(0xFFEF4444);
  static const Color foundBadge = Color(0xFF14B8A6);

  // ── Glassmorphism Tint Colors ─────────────────────────────────────
  static const Color glassLightBg = Color(0xEBF8FAFC);
  static const Color glassDarkBg = Color(0xD6132238);
  static const Color glassBorderLight = Color(0x33004AC6);
  static const Color glassBorderDark = Color(0x22FFFFFF);

  // ── Theme-Aware Helper Getters ────────────────────────────────────
  static Color surfaceFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : surface;
  }

  static Color backgroundFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : background;
  }

  static Color onSurfaceFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkOnSurface
        : onSurface;
  }

  static Color subtleTextFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkOnSurfaceVariant
        : onSurfaceVariant;
  }

  static Color borderFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkOutline
        : outlineVariant;
  }

  // ── Gradients ──────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF004AC6), Color(0xFF00687A), Color(0xFF006056)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroDarkGradient = LinearGradient(
    colors: [Color(0xFF0A142F), Color(0xFF0F2B66), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroLightGradient = LinearGradient(
    colors: [Color(0xFF1E40AF), Color(0xFF2563EB), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
