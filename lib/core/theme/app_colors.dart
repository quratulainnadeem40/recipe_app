import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary & Accent Colors
  static const Color primary = Color(0xFF8A1538); // Deep Burgundy / Crimson (Logo, Primary Buttons, Active Tab)
  static const Color primaryLight = Color(0xFFFAF0F2); // Soft Pink/Burgundy Tint (Selected Tag Backgrounds)
  static const Color primaryDark = Color(0xFF5C0B24); // Dark Crimson

  // Category & Card Colors
  static const Color categoryCard = Color(0xFF4A2C1D); // Warm Brown / Bronze (Category Grid Cards)
  static const Color categoryCardSecondary = Color(0xFF331C11); // Darker Brown Gradient Accent

  // Background & Surface
  static const Color background = Color(0xFFF9F8F8); // Warm Off-White Main Screen Background
  static const Color surface = Color(0xFFFFFFFF); // Pure White Cards & Dialog Surfaces
  static const Color darkBackground = Color(0xFF3A121F); // Dark Wine (Side Banners / Dark Theme Base)

  // Status & Tag Accents
  static const Color tagGreen = Color(0xFF2E7D32); // Selected Country Badge Green Border/Text
  static const Color tagGreenBg = Color(0xFFE8F5E9); // Selected Country Badge Soft Light Green
  static const Color ratingStar = Color(0xFFFFB800); // Gold Amber for Ratings & Favorites

  // Text Colors
  static const Color textPrimary = Color(0xFF1E1E1E); // Dark Charcoal Main Headings & Titles
  static const Color textSecondary = Color(0xFF666666); // Muted Grey Subtitles & Recipe Info
  static const Color textHint = Color(0xFF9E9E9E); // Placeholder Search Text
  static const Color textWhite = Color(0xFFFFFFFF); // Contrast Text on Dark Buttons/Cards

  // UI Elements & Borders
  static const Color inputBackground = Color(0xFFF4F4F4); // Search Bar Fill
  static const Color border = Color(0xFFE0E0E0); // Dividers & Card Outlines
  static const Color chipBackground = Color(0xFFF0F0F0); // Unselected Filter Chips & Tags
  static const Color shadow = Color(0x0F000000); 
  
  static const Color error = Color(0xFFD32F2F);
static const Color success = tagGreen;
static const Color warning = Color(0xFFF9A825);
}