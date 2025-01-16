import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/modal/contact/shortContactModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/price/priceTextWidget.dart';
import 'package:gservice5/pages/ad/viewAdPage.dart';

class SmallAdItem extends StatefulWidget {
  final Map data;
  final bool showFullInfo;
  const SmallAdItem(
      {super.key, required this.data, required this.showFullInfo});

  @override
  State<SmallAdItem> createState() => _SmallAdItemState();
}

class _SmallAdItemState extends State<SmallAdItem> {
  void showPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewAdPage(id: widget.data['id'])));
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width / 2;
    List promotions = widget.data['ad_promotions'];
    print(promotions);
    return GestureDetector(
      onTap: () => showPage(),
      onLongPress: () => onLongPressShowNumber(widget.data, context),
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
                      url: widget.data['images'][0],
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
                  promotions.isEmpty
                      ? Container()
                      : Positioned(
                          bottom: 0,
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 4),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8))),
                              child: Row(
                                  children: promotions.map((value) {
                                if (value['icon'] == null) return Container();
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: SvgPicture.network(value['icon'] ?? "",
                                      width: 13),
                                );
                              }).toList())
                              // Row(
                              //   children: [
                              //     SvgPicture.asset('assets/icons/fire.svg',
                              //         width: 16),
                              //     const Divider(indent: 2),
                              //     SvgPicture.asset('assets/icons/star.svg',
                              //         width: 16, color: ColorComponent.mainColor),
                              //     const Divider(indent: 2),
                              //     SvgPicture.asset('assets/icons/badgeCheck.svg',
                              //         width: 16),
                              //   ],
                              // ),
                              ))
                ],
              ),
            ),
            const Divider(height: 8),
            Text(widget.data['title'],
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: ColorComponent.blue['700']),
                overflow: TextOverflow.ellipsis,
                maxLines: 1),
            const Divider(height: 2),
            PriceTextWidget(prices: widget.data['prices'], fontSize: 14),
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
                          Text(widget.data['city']['title'],
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
                              Text(
                                  numberFormat(
                                      widget.data['statistics']['viewed']),
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
