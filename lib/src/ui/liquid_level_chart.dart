import 'package:flutter/material.dart';

import '../models/liquid_data.dart';
import '../theme/liquid_chart_theme.dart';
import '../utils/chart_calculator.dart';

/// Signature for a builder function that creates a custom tooltip widget.
/// The builder provides the build context and the [LiquidData] associated with the hovered/tapped bar.
typedef TooltipBuilder<T> =
    Widget Function(BuildContext context, LiquidData<T> data);

/// Signature for a builder function that provides the string text for the default tooltip.
typedef TooltipTextBuilder<T> = String Function(LiquidData<T> data);

/// A highly customizable and interactive liquid level chart widget.
/// Uses [LiquidData] with a generic type [T] for representing each column's data.
class LiquidLevelChart<T> extends StatefulWidget {
  /// List of data items to display.
  final List<LiquidData<T>> data;

  /// Theme configuration for the chart. If omitted, uses smart defaults based on `Theme.of(context)`.
  final LiquidChartTheme? theme;

  /// The text to display for the Y-axis label (e.g., 'Litters', 'Gallons').
  final String yAxisLabel;

  /// Whether the bars should animate when changing values or initially loading.
  final bool animate;

  /// Duration of the fill animation. Defaults to 1500 milliseconds.
  final Duration animationDuration;

  /// A custom builder to return entirely custom widgets for the Tooltip.
  /// If provided, this overrides [tooltipTextBuilder].
  final TooltipBuilder<T>? tooltipBuilder;

  /// A custom builder to format the text inside the default tooltip container.
  /// If provided (and [tooltipBuilder] is null), this text is shown.
  /// If neither is provided, a default text format is used.
  final TooltipTextBuilder<T>? tooltipTextBuilder;

  const LiquidLevelChart({
    super.key,
    required this.data,
    this.theme,
    this.yAxisLabel = "Litters",
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.tooltipBuilder,
    this.tooltipTextBuilder,
  });

  @override
  State<LiquidLevelChart<T>> createState() => _LiquidLevelChartState<T>();
}

class _LiquidLevelChartState<T> extends State<LiquidLevelChart<T>> {
  final _scrollController = ScrollController();

  int tabIndex = -1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Helper to resolve the active theme configuration
  LiquidChartTheme _resolveTheme(BuildContext context) {
    final defaultThemeThemeData = Theme.of(context);
    final userTheme = widget.theme ?? const LiquidChartTheme();

    return userTheme.copyWith(
      baseColor: userTheme.baseColor ?? defaultThemeThemeData.primaryColor,
      textStyle:
          userTheme.textStyle ??
          defaultThemeThemeData.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: Colors.grey,
          ),
      borderColor: userTheme.borderColor ?? defaultThemeThemeData.dividerColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox();
    }

    final resolvedTheme = _resolveTheme(context);

    List<int> scaleValues = ChartCalculator.calculateScaleValues<T>(
      widget.data,
    );
    int maxValue = scaleValues.isNotEmpty ? scaleValues[0] : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final graphAreaWidth = screenWidth * 0.75;

        return SizedBox(
          height: resolvedTheme.containerHeight + 60,
          width: screenWidth,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Row(
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        widget.yAxisLabel,
                        style: resolvedTheme.textStyle,
                      ),
                    ),
                    SizedBox(
                      height: resolvedTheme.containerHeight,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ...List.generate(scaleValues.length, (index) {
                            return Row(
                              children: [
                                Text(
                                  scaleValues[index].toString(),
                                  textAlign: TextAlign.right,
                                  style: resolvedTheme.textStyle?.copyWith(
                                    fontSize: 9,
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: resolvedTheme.borderColor?.withValues(
                                    alpha: 0.2,
                                  ),
                                  width: graphAreaWidth,
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                  width: graphAreaWidth,
                  height: resolvedTheme.containerHeight + 60,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(widget.data.length, (index) {
                        final d = widget.data[index];
                        final value = d.filled;
                        final total = d.total;

                        double scaleMax = maxValue == 0
                            ? 1
                            : maxValue.toDouble();

                        double proportionFilled = value / scaleMax;
                        double filledHeight =
                            proportionFilled *
                            (resolvedTheme.containerHeight - 15);

                        double proportionUnfilled = total / scaleMax;
                        double unfilledHeight =
                            proportionUnfilled *
                            (resolvedTheme.containerHeight - 12);

                        final itemColor = d.color ?? resolvedTheme.baseColor!;

                        // Creating the filled bar portion
                        final Widget containerBody = Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.animate)
                              AnimatedContainer(
                                duration: widget.animationDuration,
                                width: resolvedTheme.barWidth,
                                height: filledHeight,
                                color: tabIndex == -1
                                    ? itemColor
                                    : tabIndex == index
                                    ? itemColor
                                    : itemColor.withValues(alpha: 0.5),
                              )
                            else
                              Container(
                                width: resolvedTheme.barWidth,
                                height: filledHeight,
                                color: tabIndex == -1
                                    ? itemColor
                                    : tabIndex == index
                                    ? itemColor
                                    : itemColor.withValues(alpha: 0.5),
                              ),
                          ],
                        );
                        final boxDecoration = BoxDecoration(
                          color: value == total ? itemColor : null,
                          border: Border.all(
                            color: tabIndex == -1
                                ? itemColor
                                : tabIndex == index
                                ? itemColor
                                : itemColor.withValues(alpha: 0.5),
                            width: tabIndex == index ? 2 : 1,
                          ),
                        );

                        Widget barWidget;
                        if (widget.animate) {
                          barWidget = AnimatedContainer(
                            duration: widget.animationDuration,
                            width: resolvedTheme.barWidth,
                            height: unfilledHeight,
                            decoration: boxDecoration,
                            child: containerBody,
                          );
                        } else {
                          barWidget = Container(
                            width: resolvedTheme.barWidth,
                            height: unfilledHeight,
                            decoration: boxDecoration,
                            child: containerBody,
                          );
                        }
                        Widget interactiveBar;
                        if (widget.tooltipBuilder != null) {
                          interactiveBar = Tooltip(
                            richMessage: WidgetSpan(
                              child: widget.tooltipBuilder!(context, d),
                            ),
                            showDuration: const Duration(seconds: 30),
                            triggerMode: TooltipTriggerMode.tap,
                            onTriggered: () {
                              setState(() {
                                tabIndex = index;
                              });
                            },
                            child: barWidget,
                          );
                        } else {
                          String message =
                              widget.tooltipTextBuilder?.call(d) ??
                              "Filled: ${d.filled.toStringAsFixed(0)}\nUnfilled: ${d.unfilled.toStringAsFixed(0)}\nTotal: ${d.total.toStringAsFixed(0)}";
                          if (widget.tooltipTextBuilder == null &&
                              d.name != null &&
                              d.name!.isNotEmpty) {
                            message = "Name: ${d.name}\n$message";
                          }

                          interactiveBar = Tooltip(
                            message: message,
                            textStyle: resolvedTheme.tooltipTextStyle,
                            showDuration: const Duration(seconds: 30),
                            decoration: BoxDecoration(
                              color: resolvedTheme.tooltipBackgroundColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            triggerMode: TooltipTriggerMode.tap,
                            onTriggered: () {
                              setState(() {
                                tabIndex = index;
                              });
                            },
                            child: barWidget,
                          );
                        }
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: resolvedTheme.containerHeight - 6,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: interactiveBar,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: resolvedTheme.barWidth,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (d.name != null && d.name!.isNotEmpty)
                                      Text(
                                        d.name!,
                                        style: resolvedTheme.textStyle?.copyWith(fontSize: 8),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                    if (d.type != null)
                                      Text(
                                        d.type.toString(),
                                        style: resolvedTheme.textStyle?.copyWith(fontSize: 8),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
