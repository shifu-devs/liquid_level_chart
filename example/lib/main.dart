import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liquid_level_chart/liquid_level_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Level Chart Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Liquid Level Chart Demo'),
    );
  }
}

// Define a custom enum for Tank Types instead of standard strings
enum LiquidType { diesel, a80, a92, water }

extension LiquidTypeExt on LiquidType {
  String get displayName {
    switch (this) {
      case LiquidType.diesel:
        return "Diesel";
      case LiquidType.a80:
        return "A-80";
      case LiquidType.a92:
        return "A-92";
      case LiquidType.water:
        return "Water";
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Sample data simulating tanks using generic Enum
  late List<LiquidData<LiquidType>> staticData;
  late List<LiquidData<LiquidType>> animatedData;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    staticData = _generateData();
    animatedData = _generateData();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        animatedData = animatedData.map((e) {
          // Change filled randomly or sequentially
          double newFilled = e.filled + (e.total * 0.1);
          if (newFilled > e.total) {
            newFilled = 0;
          }
          return LiquidData(
            name: e.name,
            type: e.type,
            filled: newFilled,
            total: e.total,
            color: e.color,
          );
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<LiquidData<LiquidType>> _generateData() {
    return [
      LiquidData(
        name: "Tank 1",
        type: LiquidType.diesel,
        filled: 4000,
        total: 8000,
      ),
      // testing default theme color
      LiquidData(
        name: "Tank 3",
        type: LiquidType.a92,
        filled: 10000,
        total: 11500,
        color: Colors.green,
      ),
      LiquidData(
        type: LiquidType.water,
        filled: 2000,
        total: 10000,
        color: Colors.cyan,
      ), // testing no name
      LiquidData(
        name: "Tank 1",
        type: LiquidType.diesel,
        filled: 4000,
        total: 8000,
        color: Colors.blueAccent,
      ),
      LiquidData(
        name: "Tank 1",
        type: LiquidType.diesel,
        filled: 4000,
        total: 8000,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Basic Default Theme (Static):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              LiquidLevelChart<LiquidType>(data: staticData),

              const SizedBox(height: 60),
              const Text(
                'Custom Theme & Animations (Updates 1s):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              LiquidLevelChart<LiquidType>(
                data: animatedData,
                animate: true,
                animationDuration: const Duration(seconds: 1),
                theme: LiquidChartTheme(
                  containerHeight: 200,
                  containerWidth: MediaQuery.of(context).size.width,
                  barWidth: 40,
                  baseColor: Colors.deepPurple,
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  tooltipBackgroundColor: Colors.black87,
                ),
                tooltipBuilder: (context, tankData) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Custom Tooltip: ${tankData.name ?? 'Unnamed'}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Type: ${tankData.type?.displayName}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "Volume: ${(tankData.filled / tankData.total * 100).toStringAsFixed(1)}% Full",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
