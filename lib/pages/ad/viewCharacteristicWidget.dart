import 'package:flutter/material.dart';

class ViewCharacteristicWidget extends StatelessWidget {
  final List characteristics;
  const ViewCharacteristicWidget({super.key, required this.characteristics});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Column(
          children: characteristics.map((value) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Text(value['characteristic']['title'] + ": ",
                    style: TextStyle(fontSize: 15))),
            SizedBox(width: 8),
            Expanded(
                child: value['values'].runtimeType == List
                    ? InfoListCharacteristic(value['values'])
                    : InfoCharacteristic(value['values']))
          ]),
        );
      }).toList()),
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
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600));
    }).toList());
  }

  Widget InfoCharacteristic(Map data) {
    String title = "";
    if (data['title'] != null) {
      title = data['title'].toString();
    } else if (data['value'] == 1) {
      title = "Да";
    } else {
      title = data['value'].toString();
    }

    return Text(title,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600));
  }
}
