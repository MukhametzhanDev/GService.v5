import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ViewCharacteristicWidget extends StatelessWidget {
  final List characteristics;
  const ViewCharacteristicWidget({super.key, required this.characteristics});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: characteristics.map((value) {
        return Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xfff4f5f7)))),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Text(
              value['characteristic']['title'] + ": ",
              style: TextStyle(color: ColorComponent.gray['600']),
            )),
            SizedBox(width: 8),
            Expanded(
                child: value['values'] is List
                    ? InfoListCharacteristic(value['values'])
                    : InfoCharacteristic(value['values']))
          ]),
        );
      }).toList(),
    );
  }

  Widget InfoListCharacteristic(List data) {
    return Wrap(
        children: data.map((element) {
      String title = element['title'] ?? element['value'];
      int index = data.indexOf(element);
      String showComma =
          data.length == 1 || index == data.length - 1 ? "" : ", ";
      return Text(title + showComma,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500));
    }).toList());
  }

  Widget InfoCharacteristic(Map data) {
    String title = "";
    if (data['value'] is bool) {
      title = data['value'] ? "Да" : "Нет";
    } else {
      title = data['title'].toString();
    }

    return Text(title,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500));
  }
}