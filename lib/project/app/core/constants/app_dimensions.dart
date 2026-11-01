import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // Screen constraints
  static const double targetWidth = 390.0;
  static const double maxWidth = 430.0;

  // Paddings
  static const double screenPaddingH = 16.0;
  static const double cardPadding = 16.0;
  static const double cardPaddingDense = 14.0;

  // Spacing scale
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;

  // Radii
  static const double radiusCard = 12.0;
  static const double radiusButton = 10.0;
  static const double radiusInput = 8.0;
  static const double radiusChip = 6.0;
  static const double radiusPill = 999.0;

  static const BorderRadius borderRadiusCard = BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius borderRadiusButton = BorderRadius.all(Radius.circular(radiusButton));
  static const BorderRadius borderRadiusInput = BorderRadius.all(Radius.circular(radiusInput));
  static const BorderRadius borderRadiusChip = BorderRadius.all(Radius.circular(radiusChip));
  static const BorderRadius borderRadiusPill = BorderRadius.all(Radius.circular(radiusPill));

  // Component heights
  static const double buttonHeight = 46.0;
  static const double inputHeight = 44.0;
  static const double bottomNavHeight = 60.0;
  static const double appBarHeight = 56.0;

  // Border
  static const double borderWidth = 1.0;
}
