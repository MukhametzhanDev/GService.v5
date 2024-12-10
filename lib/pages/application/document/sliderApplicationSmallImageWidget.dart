import 'package:flutter/material.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/image/slider/viewImageModal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SliderApplicationSmallImageWidget extends StatelessWidget {
  final List images;
  const SliderApplicationSmallImageWidget({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("Фото",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        Divider(height: 12),
        SizedBox(
          height: 100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
                children: images.map((value) {
              int index = images.indexOf(value);
              return GestureDetector(
                onTap: () {
                  showMaterialModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          ViewImageModal(data: images, index: index));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CacheImage(
                      url: value['url'],
                      width: 150,
                      height: 100,
                      borderRadius: 8),
                ),
              );
            }).toList()),
          ),
        ),
      ],
    );
  }
}
