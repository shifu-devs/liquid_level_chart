import 'package:flutter/material.dart';

/// Data model representing a single tank/column in the liquid level chart.
///
/// [T] is the generic type for the liquid or tank category (e.g., String, Enum).
class LiquidData<T> {
  /// The optional name or label for the tank.
  final String? name;

  /// The type or category of the liquid, defined by the generic type [T].
  final T? type;

  /// The current filled volume.
  final double filled;

  /// The total capacity of the tank.
  final double total;

  /// Optional specific color for this tank. If null, the chart's theme or default color is used.
  final Color? color;

  LiquidData({
    required this.filled,
    required this.total,
    this.name,
    this.type,
    this.color,
  });

  /// The dynamically calculated unfilled volume.
  double get unfilled => total - filled;
}
