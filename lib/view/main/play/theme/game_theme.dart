// ─────────────────────────────────────────────
// CineBond – Games Module: Theme
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';

class CineBondColors {
  static const bg = Color(0xFF0A0A0F);
  static const surface = Color(0xFF13131C);
  static const surfaceElevated = Color(0xFF1C1C2A);
  static const border = Color(0xFF2A2A3D);

  // Accent per game type
  static const emojiAccent = Color(0xFFFF6B6B);
  static const blurAccent = Color(0xFF845EF7);
  static const starAccent = Color(0xFFFFB347);

  // General accents (matches app's purple ring)
  static const primary = Color(0xFF845EF7);
  static const primaryGlow = Color(0x40845EF7);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9898B0);
  static const textMuted = Color(0xFF5A5A72);

  static const correct = Color(0xFF51CF66);
  static const correctGlow = Color(0x3051CF66);
  static const wrong = Color(0xFFFF6B6B);
  static const wrongGlow = Color(0x30FF6B6B);
  static const neutral = Color(0xFF2A2A3D);

  // Gradient for game cards
  static const List<Color> emojiGradient = [Color(0xFF1C1C2A), Color(0xFF2A1C2A)];
  static const List<Color> blurGradient = [Color(0xFF1C1C2A), Color(0xFF1C1C2E)];
  static const List<Color> starGradient = [Color(0xFF1C1C2A), Color(0xFF2A1E12)];
}

class CineBondTextStyles {
  static const displayTitle = TextStyle(
    fontFamily: 'Syne',
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: CineBondColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const sectionTitle = TextStyle(
    fontFamily: 'Syne',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: CineBondColors.textPrimary,
  );

  static const cardTitle = TextStyle(
    fontFamily: 'Syne',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: CineBondColors.textPrimary,
  );

  static const body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    color: CineBondColors.textSecondary,
    height: 1.5,
  );

  static const label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: CineBondColors.textMuted,
    letterSpacing: 1.2,
  );

  static const emoji = TextStyle(
    fontSize: 52,
  );

  static const optionText = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: CineBondColors.textPrimary,
  );
}