import 'package:flutter/material.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class AdListItem extends StatefulWidget {
  const AdListItem({super.key});

  @override
  State<AdListItem> createState() => _AdListItemState();
}

class _AdListItemState extends State<AdListItem> {
  @override
  Widget build(BuildContext context) {
    double IMAGE_WIDTH = MediaQuery.of(context).size.width - 32;
    double IMAGE_HEIGHT = IMAGE_WIDTH / 1.4;

    return GestureDetector(
      child: Column(
        children: [
          SizedBox(
            width: IMAGE_WIDTH,
            height: IMAGE_HEIGHT,
            child: Stack(
              children: [
                CacheImage(
                    url:
                        "https://images.unsplash.com/photo-1584186118422-895ef18c418d?q=80&w=2970&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    width: IMAGE_WIDTH,
                    height: IMAGE_HEIGHT,
                    borderRadius: 8),
                Positioned(
                  top: 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: ColorComponent.mainColor,
                            borderRadius: BorderRadius.circular(4)),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
