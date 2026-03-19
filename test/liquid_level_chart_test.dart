import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_level_chart/liquid_level_chart.dart';

void main() {
  testWidgets('LiquidLevelChart renders correctly with generics and theme', (WidgetTester tester) async {
    final List<LiquidData<String>> data = [
      LiquidData<String>(
        name: "Tank 1",
        type: "Diesel",
        filled: 50,
        total: 100,
        color: Colors.blueAccent,
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: LiquidLevelChart<String>(
          data: data,
          theme: const LiquidChartTheme(
            containerHeight: 250,
            barWidth: 40,
          ),
          tooltipTextBuilder: (data) => "My Custom Text",
        ),
      ),
    ));

    expect(find.byType(LiquidLevelChart<String>), findsOneWidget);
    expect(find.text("Tank 1"), findsOneWidget);
    expect(find.text("Diesel"), findsOneWidget);
  });
}
