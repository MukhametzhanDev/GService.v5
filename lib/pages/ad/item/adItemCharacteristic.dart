import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class AdItemCharacteristic extends StatelessWidget {
  final Map data;
  const AdItemCharacteristic({super.key, required this.data});

  String getTitle(value) {
    String measurement_unit = value['values']['measurement_unit'] ?? "";
    if (value['values']['title'].runtimeType == String) {
      if (value['values']['title'].length > 3) {
        return "${value['values']['title']} $measurement_unit";
      } else {
        return "${value['characteristic']['title']}: ${value['values']['title'].toString().toLowerCase()}";
      }
    } else if (value['values']['title'].runtimeType == int) {
      return "${value['values']['title']} $measurement_unit";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    List characteristics = data['characteristics'];
    // [
    //   {
    //     "characteristic": {"title": ""},
    //     "values": {
    //       "value": "",
    //       "title": data['category']['title'],
    //       "measurement_unit": null
    //     }
    //   },
    //   ...data['characteristics']
    // ];
    double lineHeight = 15.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data['category']['title'] ?? "",
            style: TextStyle(
                fontSize: 13,
                color: ColorComponent.gray['700'],
                fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis),
        Divider(height: 4),
        Wrap(
            runSpacing: 1.5,
            children: characteristics.map((value) {
              int index = characteristics.indexOf(value);
              bool last = index == characteristics.length - 1;
              String title = getTitle(value);
              if (title.length > 3) {
                return richTextItem(title, last);
              } else {
                return Container();
              }
            }).toList()),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            int calculateMaxLines(BoxConstraints constraints) {
              return (constraints.maxHeight / (lineHeight)).floor();
            }

            return Text(data['description'] ?? "",
                style: TextStyle(
                  fontSize: 13,
                  color: ColorComponent.gray['600'],
                ),
                maxLines: calculateMaxLines(constraints),
                overflow: TextOverflow.ellipsis);
          }),
        )
      ],
    );
  }

  RichText richTextItem(title, last) {
    return RichText(
      text: TextSpan(style: const TextStyle(fontSize: 13), children: [
        TextSpan(
            text: title, style: TextStyle(color: ColorComponent.gray['600'])),
        TextSpan(
            text: " | ", style: TextStyle(color: ColorComponent.gray['300']))
      ]),
    );
  }
}
