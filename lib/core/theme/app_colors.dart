import 'package:flutter/material.dart';

/// Coffee-shop palette — "rust & butter" edition.
///
/// Sampled from the reference cup artwork: a warm rust-brown frame, pale
/// butter-yellow sheets, golden accents and warm white highlights.
///
/// Every screen reads its colors from here, so retinting the whole app is a
/// matter of editing these constants — no widget code has to change.
class AppColors {
  AppColors._();

  // Core palette (reference image)
  /// Rust cocoa — page frame, primary text, filled buttons.
  static const Color darkEspresso = Color(0xFF8C4527);

  /// Golden accent — primary CTAs and price chips (was a pastel pink).
  static const Color pastelPink = Color(0xFFF3DB96);

  /// Warm white — loading poster, "on-dark" outlines and labels (was blue).
  static const Color powderBlue = Color(0xFFFBF6E6);

  /// Pale butter — the big content sheet, and light text on the rust frame.
  static const Color creamPaper = Color(0xFFF8F0C6);

  /// Deepest roast — reserved for the strongest contrast.
  static const Color darkInk = Color(0xFF4E2313);

  // Surfaces
  static const Color creamBackground = creamPaper;

  /// Slightly deeper butter for tiles, notes and chips sitting on the sheet.
  static const Color warmCream = Color(0xFFF1E7A9);

  static const Color cardSurface = Color(0xFFFCFAF2);
  static const Color paperInk = creamPaper;

  // Accent aliases
  static const Color kaveaOrange = pastelPink;
  static const Color kaveaOrangeDeep = Color(0xFFE0B45C);

  static const Color terracotta = darkEspresso;
  static const Color terracottaDark = darkInk;
  static const Color terracottaLight = pastelPink;

  static const Color stripeBlue = powderBlue;
  static const Color stripeBlueDeep = Color(0xFFE7D9B4);

  static const Color leather = darkEspresso;
  static const Color leatherSoft = Color(0xFF7A3A21);

  static const Color darkCoffee = darkInk;

  /// Secondary text/icons on the butter surfaces.
  static const Color coffeeLight = Color(0xFF8A5A3C);

  /// Quietest text — hints and captions.
  static const Color textMuted = Color(0xFF8F7C6B);

  static const Color signatureGreen = powderBlue;
  static const Color signatureGreenLight = Color(0xFFF5EFDB);

  static const Color goldenHour = pastelPink;
  static const Color goldenLight = Color(0xFFFBF2D4);
}
