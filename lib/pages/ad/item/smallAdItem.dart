import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/modal/contact/shortContactModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class SmallAdItem extends StatefulWidget {
  final int index;
  final bool showFullInfo;
  const SmallAdItem(
      {super.key, required this.index, required this.showFullInfo});

  @override
  State<SmallAdItem> createState() => _SmallAdItemState();
}

class _SmallAdItemState extends State<SmallAdItem> {
  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width / 2;
    return GestureDetector(
      onLongPress: () => onLongPressShowNumber({}, context),
      child: Container(
        width: itemWidth - 24,
        height: itemWidth - 2,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: itemWidth - 24,
              height: itemWidth / 1.7,
              child: Stack(
                children: [
                  CacheImage(
                      url:
                          "https://images.unsplash.com/photo-1583024011792-b165975b52f5?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjZ8fGV4Y2F2YXRvcnxlbnwwfHwwfHx8MA%3D%3D",
                      width: itemWidth - 24,
                      height: itemWidth / 1.7,
                      borderRadius: 10),
                  // Positioned(
                  //   top: 10,
                  //   right: 0,
                  //   child: Container(
                  //     height: 20,
                  //     padding: const EdgeInsets.symmetric(horizontal: 8),
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //         color: ColorComponent.mainColor,
                  //         borderRadius: const BorderRadius.only(
                  //             topLeft: Radius.circular(4),
                  //             bottomLeft: Radius.circular(4))),
                  //     child: Text(widget.index == 1 ? "Продажа" : "Аренда",
                  //         style: const TextStyle(
                  //             height: 1,
                  //             fontSize: 11,
                  //             fontWeight: FontWeight.w500)),
                  //   ),
                  // ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8))),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/fire.svg',
                                width: 16),
                            const Divider(indent: 2),
                            SvgPicture.asset('assets/icons/star.svg',
                                width: 16, color: ColorComponent.mainColor),
                            const Divider(indent: 2),
                            SvgPicture.asset('assets/icons/badgeCheck.svg',
                                width: 16),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            const Divider(height: 8),
            Text(widget.index == 1 ? "SDLG 3CX" : "Экскаватор погрузчик ",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: ColorComponent.blue['700'])),
            const Divider(height: 2),
            widget.index == 1
                ? const Text("Договорная",
                    // "${priceFormat(15000000)} ₸",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))
                : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    RichText(
                        text: const TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                            children: [
                          TextSpan(
                              text: "3 000 ", style: TextStyle(fontSize: 12)),
                          TextSpan(
                              text: "₸/час",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 11)),
                        ])),
                    Text(" | ",
                        style: TextStyle(color: ColorComponent.gray['400'])),
                    RichText(
                        text: const TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            children: [
                          TextSpan(
                              text: "25 000 ", style: TextStyle(fontSize: 12)),
                          TextSpan(
                              text: "₸/смена",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 11)),
                        ])),
                  ]),
            // Text("${priceFormat(15000000)} ₸",
            //     style: TextStyle(
            //         fontSize: 13,
            //         fontWeight: FontWeight.w700,
            //         color: ColorComponent.blue['500'])),
            widget.showFullInfo
                ? Column(
                    children: [
                      const Divider(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Алматы",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: ColorComponent.gray['500'])),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/eye.svg',
                                width: 14,
                                color: ColorComponent.gray["400"],
                              ),
                              const Divider(indent: 4),
                              Text(numberFormat(120),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorComponent.gray["500"])),
                              const Divider(indent: 4),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
