import 'package:flutter/material.dart';
import 'package:healther/theme/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Title text style
  static get titleMediumOnPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );

  static get titleMediumPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
      );

  static get titleMediumBlack =>
      theme.textTheme.titleMedium!.copyWith(color: appTheme.black900);

  static get titleSmallGray50 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray50,
      );
}

extension on TextStyle {
  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }
}
