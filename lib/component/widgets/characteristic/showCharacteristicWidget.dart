import 'package:flutter/material.dart';

class ShowCharacteristicWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const ShowCharacteristicWidget({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return subTitle == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(children: [
              Expanded(child: Text(title ?? '')),
              Divider(),
              Expanded(
                  child: Text(subTitle ?? '',
                      style: TextStyle(fontWeight: FontWeight.w500)))
            ]),
          );
  }
}
