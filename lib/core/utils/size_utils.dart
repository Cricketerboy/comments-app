import 'package:flutter/material.dart';
import 'dart:ui' as ui;

const num FIGMA_DESIGN_WIDTH = 390;
const num FIGMA_DESIGN_HEIGHT = 844;
const num FIGMA_DESIGN_STATUS_BAR = 0;

typedef ResponsiveBuild = Widget Function(
  BuildContext context,
  Orientation orientation,
  DeviceType deviceType,
);

class Sizer extends StatelessWidget {
  const Sizer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeUtils.setScreenSize(
          MediaQuery.of(context).size,
          orientation,
        );
        return builder(context, orientation, SizeUtils.deviceType);
      });
    });
  }
}

class SizeUtils {
  static late Size screenSize =
      Size(FIGMA_DESIGN_WIDTH.toDouble(), FIGMA_DESIGN_HEIGHT.toDouble());
  static late Orientation orientation;
  static late DeviceType deviceType;

  static late double width;
  static late double height;

  SizeUtils() {
    setScreenSize(screenSize, orientation);
  }

  static void setScreenSize(Size size, Orientation currentOrientation) {
    screenSize = size;
    orientation = currentOrientation;

    if (orientation == Orientation.portrait) {
      width = screenSize.width.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = screenSize.height.isNonZero();
    } else {
      width = screenSize.height.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = screenSize.width.isNonZero();
    }
    deviceType = DeviceType.mobile;
  }
}

extension ResponsiveExtension on num {
  double get _width => SizeUtils.screenSize.width;
  double get _height => SizeUtils.screenSize.height;

  double get h => ((this * _width) / FIGMA_DESIGN_WIDTH);

  double get v =>
      (this * _height) / (FIGMA_DESIGN_HEIGHT - FIGMA_DESIGN_STATUS_BAR);

  double get adaptSize {
    var height = v;
    var width = h;
    return height < width ? height.toDoubleValue() : width.toDoubleValue();
  }

  double get fSize => adaptSize;
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(this.toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

enum DeviceType { mobile, tablet, desktop }
