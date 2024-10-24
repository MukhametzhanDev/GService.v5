import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ShowStickersList extends StatefulWidget {
  const ShowStickersList({super.key});

  @override
  State<ShowStickersList> createState() => _ShowStickersListState();
}

class _ShowStickersListState extends State<ShowStickersList> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(3, (index) => index).toList().map((value) {
          return Container(
            height: 24,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: ColorComponent.mainColor.withOpacity(.3)),
            child: Text("Тег",
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, height: 1)),
          );
        }).toList());
  }
}
