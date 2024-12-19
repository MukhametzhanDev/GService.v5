import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ShowCharacteristicWidget extends StatelessWidget {
  final String? title;
  final subTitle;
  const ShowCharacteristicWidget({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return subTitle == null
        ? Container()
        : Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xfff4f5f7)))),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(children: [
              Expanded(
                  child: Text(
                "$title: " ?? "",
                style: TextStyle(color: ColorComponent.gray['600']),
              )),
              Expanded(
                  child: subTitle.runtimeType == List
                      ? InfoListCharacteristic(subTitle)
                      : Text(subTitle['title'] ?? "",
                          style: const TextStyle(fontWeight: FontWeight.w500)))
            ]),
          );
  }
}

Widget InfoListCharacteristic(List data) {
  return Wrap(
      children: data.map((element) {
    String title = element['title'] ?? element['value'];
    int index = data.indexOf(element);
    String showComma = data.length == 1 || index == data.length - 1 ? "" : ", ";
    return Text(title + showComma,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500));
  }).toList());
}
