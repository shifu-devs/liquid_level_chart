import 'package:flutter/material.dart';

/// Defines the styling properties for the [LiquidLevelChart].
class LiquidChartTheme {
  /// Overall height, width of the chart area.
  final double containerHeight;
  final double? containerWidth;

  /// Width of each bar in the chart.
  final double barWidth;

  /// The main color used for filled areas if no specific color is provided in [LiquidData].
  final Color? baseColor;

  /// Text style for labels (X-axis, Y-axis).
  final TextStyle? textStyle;

  /// Color for lines and borders (e.g., scale lines, bar borders).
  final Color? borderColor;

  /// Style for the tooltip.
  final TextStyle tooltipTextStyle;

  /// Background color of the tooltip.
  final Color tooltipBackgroundColor;

  const LiquidChartTheme({
    this.containerHeight = 200.0,
    this.containerWidth,
    this.barWidth = 35.0,
    this.baseColor,
    this.textStyle,
    this.borderColor,
    this.tooltipTextStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color.fromARGB(255, 82, 82, 82),
    ),
    this.tooltipBackgroundColor = const Color.fromARGB(255, 243, 243, 243),
  });

  /// Factory constructor to copy properties with modifications
  LiquidChartTheme copyWith({
    double? containerHeight,
    double? containerWidth,
    double? barWidth,
    Color? baseColor,
    TextStyle? textStyle,
    Color? borderColor,
    TextStyle? tooltipTextStyle,
    Color? tooltipBackgroundColor,
  }) {
    return LiquidChartTheme(
      containerHeight: containerHeight ?? this.containerHeight,
      containerWidth: containerWidth ?? this.containerWidth,
      barWidth: barWidth ?? this.barWidth,
      baseColor: baseColor ?? this.baseColor,
      textStyle: textStyle ?? this.textStyle,
      borderColor: borderColor ?? this.borderColor,
      tooltipTextStyle: tooltipTextStyle ?? this.tooltipTextStyle,
      tooltipBackgroundColor:
          tooltipBackgroundColor ?? this.tooltipBackgroundColor,
    );
  }
}
