import 'package:flutter/material.dart';
import 'package:healther/core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray100,
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray50,
      );

  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary,
      );
}

class BorderRadiusStyle {
  // Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10.h,
      );

  static BorderRadius get roundedBorder22 => BorderRadius.circular(
        22.h,
      );
}
