import 'package:flutter/material.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/image/slider/viewImageModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SmallSliderImageWidget extends StatelessWidget {
  final List images;
  const SmallSliderImageWidget({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return images.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 12),
              Divider(height: 1, color: ColorComponent.gray['50']),
              const Divider(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Фото",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              const Divider(height: 12),
              SizedBox(
                height: 70,
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: images.map((value) {
                      int index = images.indexOf(value);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ViewImageModal(
                                    data: images, index: index);
                              },
                            );
                          },
                          child: CacheImage(
                              url: value,
                              width: 101,
                              height: 70,
                              borderRadius: 8),
                        ),
                      );
                    }).toList())),
              ),
            ],
          );
  }
}
