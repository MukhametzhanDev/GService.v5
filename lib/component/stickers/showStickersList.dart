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
    return Wrap(
        runSpacing: 8,
        children: widget.data.map((value) {
          if (value?['active'] ?? false) {
            return Container(
              height: 24,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5.5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: ColorComponent.mainColor.withOpacity(.3)),
              child: Text(value['title'],
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500, height: 1)),
            );
          } else {
            return const SizedBox.shrink();
          }
        }).toList());
  }
}
