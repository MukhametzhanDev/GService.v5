import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:intl/intl.dart';

class ChartWidget extends StatefulWidget {
  final List data;
  final String type;
  const ChartWidget({super.key, required this.data, required this.type});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  ScrollController scrollController = ScrollController();
  List data = [];
  int max = 0;

  @override
  void initState() {
    formattedData();
    super.initState();
  }

  void formattedData() {
    widget.data.forEach((value) {
      data.add(value[widget.type]);
    });
    print(data);
    max = data.reduce((a, b) => a > b ? a : b);
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

  String formattedISODate(String isoDate) {
    DateTime parsedDate = DateTime.parse(isoDate);
    String formattedDate = DateFormat('d MMM', 'ru').format(parsedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    double chartWidgetHeight = (MediaQuery.of(context).size.height / 2.5) + 50;
    double chartMaxHeight = MediaQuery.of(context).size.height / 3 - 15;
    return Column(
      children: [
        Scrollbar(
          thumbVisibility: true,
          thickness: 6,
          controller: scrollController,
          radius: Radius.circular(12),
          child: SizedBox(
            height: chartWidgetHeight,
            child: Container(
              margin: EdgeInsets.only(bottom: 25),
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: const Color(0xffe5e7eb))),
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  Map value = widget.data.reversed.toList()[index];
                  int heightValue = value[widget.type];
                  return SizedBox(
                    width: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(heightValue.toString(),
                            textAlign: TextAlign.center),
                        const Divider(height: 8),
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            padding: const EdgeInsets.only(top: 12),
                            height: heightValue == 0
                                ? 1
                                : getHeight(heightValue, chartMaxHeight),
                            decoration: BoxDecoration(
                                color: ColorComponent.mainColor,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8))),
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            constraints:
                                BoxConstraints(maxHeight: chartMaxHeight)),
                        const Divider(height: 10),
                        Text(formattedISODate(value['date']),
                            style: TextStyle(
                                color: ColorComponent.gray['500'],
                                fontSize: 12)),
                        const Divider(height: 30),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
