# Liquid Level Chart

A highly customizable, interactive, and beautifully animated Flutter package for displaying liquid levels in tanks or containers as dynamic bar charts.

![Demo](https://raw.githubusercontent.com/shifu-devs/liquid_level_chart/main/demo.gif)

## Features

- Display multiple tanks/containers with custom labels and colors.
- Interactive tooltip to show exact values upon tap.
- Smooth animations for bars filling up when values change.
- Highly customizable axes, labels, margins, and colors.
- Automatically handles scale calculations based on data values.

## Getting started

In your `pubspec.yaml` file, add:

```yaml
dependencies:
  liquid_level_chart: ^0.0.1
```

Then, import the package in your file:

```dart
import 'package:liquid_level_chart/liquid_level_chart.dart';
```

## Usage

Create a list of `LiquidData<T>` and pass it to the `LiquidLevelChart<T>` widget.
You can use `LiquidChartTheme` to heavily customize the look, or rely on `Theme.of(context)` defaults.

```dart
import 'package:flutter/material.dart';
import 'package:liquid_level_chart/liquid_level_chart.dart';

// You can use Strings, Enums, or any custom class for your types.
enum LiquidType { diesel, a80 }

class MyChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<LiquidData<LiquidType>> data = [
      LiquidData(
        name: "Tank 1",
        type: LiquidType.diesel,
        filled: 60000000,
        total: 80000000,
        color: Colors.blueAccent,
      ),
      LiquidData(
        name: "Tank 2",
        type: LiquidType.a80,
        filled: 5500000,
        total: 75000000,
        color: Colors.orangeAccent,
      ),
    ];

    return Scaffold(
      body: Center(
        child: LiquidLevelChart<LiquidType>(
          data: data,
          theme: const LiquidChartTheme(
            containerHeight: 250,
            barWidth: 40,
            baseColor: Colors.blueAccent,
          ),
          yAxisLabel: 'Volume (L)',
          animate: true, // Optional: animate the bars filling up
          animationDuration: const Duration(seconds: 2),
        ),
      ),
    );
  }
}
```

## Additional information

For more information, feel free to check out the example provided in the `example` folder. 
Contribute to the project by submitting issues or pull requests on [GitHub](https://github.com/shifu-devs/liquid_level_chart).
