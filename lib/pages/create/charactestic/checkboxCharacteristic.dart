import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class CheckboxCharacteristic extends StatefulWidget {
  final Map value;
  const CheckboxCharacteristic({super.key, required this.value});

  @override
  State<CheckboxCharacteristic> createState() => _CheckboxCharacteristicState();
}

class _CheckboxCharacteristicState extends State<CheckboxCharacteristic> {
  bool active = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    if (CreateData.characteristic[widget.value['id']] != null &&
        CreateData.characteristic[widget.value['id']]) {
      active = CreateData.characteristic[widget.value['id']];
    }
    setState(() {});
  }

  void onChanged() {
    active = !active;
    CreateData.characteristic["${widget.value['id']}"] = active;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Row(children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: active
                    ? ColorComponent.blue['700']
                    : ColorComponent.gray['200'],
                borderRadius: BorderRadius.circular(4)),
            child: active
                ? SvgPicture.asset('assets/icons/checkMini.svg', width: 18)
                : Container(),
          ),
          Expanded(
              child: Text(widget.value['title'],
                  style: const TextStyle(fontWeight: FontWeight.w500)))
        ]),
      ),
    );
  }
}
