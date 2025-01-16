import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ShowStickersList extends StatefulWidget {
  final List data;
  const ShowStickersList({super.key, required this.data});

  @override
  State<ShowStickersList> createState() => _ShowStickersListState();
}

class _ShowStickersListState extends State<ShowStickersList> {
  @override
  Widget build(BuildContext context) {
    return widget.data.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: 6),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: widget.data.map((value) {
                return Container(
                  // height: 26,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: ColorComponent.mainColor.withOpacity(.4)),
                  child: Text(value['title'],
                      style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          height: 1)),
                );
              }).toList()),
            ),
          );
  }
}
