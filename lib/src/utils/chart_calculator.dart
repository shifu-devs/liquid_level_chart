import 'dart:math';
import '../models/liquid_data.dart';

/// Utility class for chart-related calculations to maintain clean architecture.
class ChartCalculator {
  /// Calculates the maximum scale value and the intermediate scale ticks 
  /// for the Y-axis based on the provided data.
  static List<int> calculateScaleValues<T>(List<LiquidData<T>> data, {int numberOfSteps = 5}) {
    if (data.isEmpty) {
      return List.generate(numberOfSteps + 1, (index) => (numberOfSteps - index) * 10);
    }

    double maxValueRaw = 0;
    for (var element in data) {
      if (element.total > maxValueRaw) {
        maxValueRaw = element.total;
      }
    }

    int maxValue = maxValueRaw.toInt();
    if (maxValue == 0) {
      return List.generate(numberOfSteps + 1, (index) => (numberOfSteps - index) * 10);
    }

    int digits = maxValue.toString().length - 3;
    digits = digits <= 0 ? 1 : digits;
    
    final int digitMultiplier = pow(10, digits).toInt() * digits;
    maxValue = ((maxValue ~/ digitMultiplier) + 1) * digitMultiplier;

    int step = (maxValue / numberOfSteps).round();
    int stepDigit = step.toString().length - 3;
    stepDigit = stepDigit <= 0 ? 1 : stepDigit;

    final int stepMultiplier = pow(10, stepDigit).toInt() * stepDigit;
    int stepOf = ((step ~/ stepMultiplier) + 1) * stepMultiplier;
    
    List<int> scaleValues = [];
    for (var i = numberOfSteps; i >= 0; i--) {
      scaleValues.add(i * stepOf);
    }

    return scaleValues;
  }
}
