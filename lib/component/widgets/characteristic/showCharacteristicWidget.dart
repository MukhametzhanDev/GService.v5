import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ShowCharacteristicWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const ShowCharacteristicWidget({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return subTitle == null
        ? Container()
        : Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xfff4f5f7)))),
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(children: [
              Expanded(
                  child: Text(
                "$title: " ?? "",
                style: TextStyle(color: ColorComponent.gray['600']),
              )),
              Expanded(
                  child: Text(subTitle ?? "",
                      style: TextStyle(fontWeight: FontWeight.w500)))
            ]),
          );
  }
}
