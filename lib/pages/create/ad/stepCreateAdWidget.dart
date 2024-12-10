import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class StepCreateAdWidget extends StatefulWidget {
  final Map options;
  final int activeIndex;
  const StepCreateAdWidget(
      {super.key, required this.options, required this.activeIndex});

  @override
  State<StepCreateAdWidget> createState() => _StepCreateAdWidgetState();
}

class _StepCreateAdWidgetState extends State<StepCreateAdWidget> {
  List lengthLine = [];

  @override
  void initState() {
    super.initState();
    getLength();
  }

  void getLength() {
    int childCharacteristicCount =
        widget.options['characteristics']['is_available'] ? 2 : 1;
    int optionsLength = widget.options['necessary_inputs'].length;
    List prices = widget.options['prices'] ?? [];
    int priceLength = prices.isEmpty ? 0 : 1;
    int allLength = childCharacteristicCount + optionsLength + 2 + priceLength;
    lengthLine = List<int>.generate(allLength, (i) => i + 1);
    setState(() {});
  }

  Color? activeColor(index) {
    return widget.activeIndex + 1 == index
        ? ColorComponent.mainColor
        : widget.activeIndex + 1 > index
            ? ColorComponent.mainColor.withOpacity(.5)
            : ColorComponent.gray['200'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 3,
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
