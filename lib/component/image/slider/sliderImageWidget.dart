import 'package:flutter/material.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/image/slider/viewImageModal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SliderImageWidget extends StatelessWidget {
  final List images;
  const SliderImageWidget({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    double IMAGE_WIDTH = MediaQuery.of(context).size.width - 32;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: IMAGE_WIDTH / 1.7,
      child: PageView(
        children: images.map((value) {
          int index = images.indexOf(value);
          return TextButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      ViewImageModal(data: images, index: index));
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero, backgroundColor: Colors.transparent),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CacheImage(
                    url: value['url'],
                    width: IMAGE_WIDTH,
                    height: IMAGE_WIDTH / 1.7,
                    borderRadius: 8),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff9A9A9ABF).withOpacity(.75)),
                    margin: EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(minHeight: 23, minWidth: 42),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text("${index + 1}/${images.length}",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
