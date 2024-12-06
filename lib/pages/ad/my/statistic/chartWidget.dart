import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ChartWidget extends StatefulWidget {
  ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  ScrollController scrollController = ScrollController();
  List data = List.generate(10, (index) => index * Random().nextInt(1000));
  int max = 0;

  @override
  void initState() {
    max = data.reduce((a, b) => a > b ? a : b);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  double getHeight(int value, double maxHeight) {
    double percentChart = 0.0;
    percentChart = value * 100 / max;
    double percentHeight = maxHeight * percentChart / 100;
    percentHeight = percentHeight == 0 ? 0.5 : percentHeight;
    return percentHeight;
  }

  @override
  Widget build(BuildContext context) {
    double CHART_MAX_HEIGHT = MediaQuery.of(context).size.height / 3 - 15;
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: const Color(0xffe5e7eb))),
      child: ListView.builder(
        controller: scrollController,
        reverse: true,
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          int value = data[index];
          return SizedBox(
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(value.toString(), textAlign: TextAlign.center),
                const Divider(height: 8),
                AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.only(top: 12),
                    height: getHeight(value, CHART_MAX_HEIGHT),
                    decoration: BoxDecoration(
                        color: ColorComponent.mainColor,
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(8))),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    constraints: BoxConstraints(maxHeight: CHART_MAX_HEIGHT)),
                const Divider(height: 10),
                Text("17 Окт",
                    style: TextStyle(
                        color: ColorComponent.gray['500'], fontSize: 12)),
                const Divider(height: 8),
                // Scrollbar(
                //     thumbVisibility: true,
                //     controller: scrollController,
                //     radius: const Radius.circular(8.0),
                //     thickness: 5,
                //     child: Container())
              ],
            ),
          );
        },
      ),
    );
  }
}
