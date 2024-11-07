import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class StepIndicator extends StatefulWidget {
  final int lengthLine;
  final int activeIndex;
  const StepIndicator(
      {super.key, required this.lengthLine, required this.activeIndex});

  @override
  State<StepIndicator> createState() => _StepIndicatorState();
}

class _StepIndicatorState extends State<StepIndicator> {
  List lengthLine = [];

  @override
  void initState() {
    super.initState();
    lengthLine = List<int>.generate(widget.lengthLine, (i) => i );
  }

  Color activeColor(index) {
    return widget.activeIndex == index
        ? ColorComponent.mainColor
        : widget.activeIndex > index
            ? ColorComponent.mainColor
            : Color(0xffffe5e7eb);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 4,
      child: Row(
          children: lengthLine.map((index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == lengthLine.length ? 0 : 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: activeColor(index)),
          ),
        );
      }).toList()),
    );
  }
}
