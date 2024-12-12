import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/image/slider/viewImageModal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SliderImageWidget extends StatefulWidget {
  final List images;
  const SliderImageWidget({super.key, required this.images});

  @override
  State<SliderImageWidget> createState() => _SliderImageWidgetState();
}

class _SliderImageWidgetState extends State<SliderImageWidget> {
  int currentIndex = 0;
  PageController pageController = PageController();
  // ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    pageController.dispose();
    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double IMAGE_WIDTH = MediaQuery.of(context).size.width;
    return widget.images.isEmpty
        ? Container()
        : SizedBox(
            height: IMAGE_WIDTH / 1.13,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: IMAGE_WIDTH / 1.2,
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (value) {
                      currentIndex = value;
                      // double offset = (value * 101) + (4 * value).toDouble();
                      // scrollController.animateTo(
                      //   offset,
                      //   duration: Duration(milliseconds: 300),
                      //   curve: Curves.easeInOut,
                      // );
                      setState(() {});
                    },
                    children: widget.images.map((value) {
                      String url =
                          value.runtimeType == String ? value : value['url'];
                      int index = widget.images.indexOf(value);
                      return TextButton(
                        onPressed: () {
                          showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => ViewImageModal(
                                  data: widget.images, index: index));
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CacheImage(
                                url: url,
                                width: IMAGE_WIDTH,
                                height: IMAGE_WIDTH / 1.2,
                                borderRadius: 0),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color:
                                        Color(0xff9A9A9ABF).withOpacity(.75)),
                                margin: EdgeInsets.only(bottom: 12),
                                constraints:
                                    BoxConstraints(minHeight: 23, minWidth: 42),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: Text(
                                    "${index + 1}/${widget.images.length}",
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
                ),
                Positioned(
                    bottom: 0,
                    right: 15,
                    child: SvgPicture.asset('assets/icons/logo.svg', width: 46))
              ],
            ),
          );
    // Divider(indent: 8),
    // SizedBox(
    //     height: 70,
    //     child: ListView.builder(
    //       itemCount: widget.images.length,
    //       physics: ClampingScrollPhysics(),
    //       padding: EdgeInsets.symmetric(horizontal: 11),
    //       scrollDirection: Axis.horizontal,
    //       controller: scrollController,
    //       itemBuilder: (context, index) {
    //         var value = widget.images[index];
    //         String url = value.runtimeType == String ? value : value['url'];
    //         return GestureDetector(
    //             onTap: () {
    //               pageController.animateToPage(index,
    //                   duration: Duration(milliseconds: 300),
    //                   curve: Curves.linearToEaseOut);
    //             },
    //             child: Container(
    //               decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(8),
    //                   border: Border.all(
    //                       width: 2,
    //                       color: index == currentIndex
    //                           ? ColorComponent.mainColor
    //                           : Colors.transparent)),
    //               margin: const EdgeInsets.symmetric(horizontal: 4.0),
    //               child: CacheImage(
    //                   url: url, width: 101, height: 70, borderRadius: 6),
    //             ));
    //       },
    //     ))
  }
}
