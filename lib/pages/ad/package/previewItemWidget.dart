import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/stickers/showStickersList.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/price/priceTextWidget.dart';
import 'package:gservice5/pages/ad/item/adItemCharacteristic.dart';
import 'package:intl/intl.dart';

class PreviewItemWidget extends StatefulWidget {
  final int adId;
  final Map? package;
  final List stickers;
  // final List promotions;
  const PreviewItemWidget(
      {super.key,
      required this.adId,
      required this.package,
      // required this.promotions,
      required this.stickers});

  @override
  State<PreviewItemWidget> createState() => _PreviewItemWidgetState();
}

class _PreviewItemWidgetState extends State<PreviewItemWidget> {
  int index = 0;
  Map data = {};

  @override
  void initState() {
    getAdData();
    super.initState();
  }

  void getAdData() async {
    print(widget.adId);
    try {
      Response response = await dio.get("/ad-list-data/${widget.adId}");
      if (response.data['success']) {
        data = response.data['data'];
        setState(() {});
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  Color getColor() {
    if (widget.package != null) {
      List promotions = widget.package?['promotions'];
      var value = promotions.where((value) => value['type'] == "color");
      Color color = value.isEmpty
          ? Colors.white
          : Color(int.parse(value.first['value'])).withOpacity(.1);
      return color;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("widget.stickers ${widget.stickers}");
    double imageHeight = 120.0;
    List promotions = widget.package?['promotions'] ?? [];
    return data.isEmpty
        ? Container()
        : GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(12),
                  color: getColor(),
                  border: Border.all(width: 1, color: const Color(0xffeeeeee))),
              // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['title'] ?? "",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorComponent.blue['700']),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                                height: 24,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: ColorComponent.mainColor,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text(data['category']['title'],
                                    style: const TextStyle(
                                        height: 1,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)))
                            // Row(
                            // children: [
                            // Divider(indent: 8),
                            // FavoriteButton()
                            //  ],
                            //  )
                          ],
                        ),
                        const Divider(height: 8),
                        PriceTextWidget(prices: data['prices'], fontSize: 15),
                        const Divider(height: 12),
                        SizedBox(
                          height: imageHeight,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.2,
                                height: imageHeight,
                                child: Stack(
                                  children: [
                                    CacheImage(
                                        url: data['images'][0],
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        height: imageHeight,
                                        borderRadius: 8),
                                    // Positioned(
                                    //   top: 8,
                                    //   left: 8,
                                    //   child: ClipRRect(
                                    //     child: BackdropFilter(
                                    //       filter: ImageFilter.blur(
                                    //           sigmaX: 4.0, sigmaY: 4.0),
                                    //       child: Container(
                                    //         decoration: BoxDecoration(
                                    //             color: Colors.white
                                    //                 .withOpacity(.7),
                                    //             borderRadius:
                                    //                 BorderRadius.circular(4)),
                                    //         padding: const EdgeInsets.symmetric(
                                    //             vertical: 3, horizontal: 8),
                                    //         child: Row(
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.center,
                                    //           children: [
                                    //             SvgPicture.asset(
                                    //                 'assets/icons/badgeCheck.svg',
                                    //                 width: 16),
                                    //             const Divider(indent: 4),
                                    //             Text("От диллера",
                                    //                 style: TextStyle(
                                    //                     fontSize: 12,
                                    //                     fontWeight:
                                    //                         FontWeight.w600,
                                    //                     color: ColorComponent
                                    //                         .blue['500']))
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              const Divider(indent: 12),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(data['sub_title'],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          height: 1.3),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const Divider(height: 8),
                                  Expanded(
                                      child: AdItemCharacteristic(data: data)),
                                  // Text(
                                  //     "На заказы от 3-х смен мы предоставляем скидку. Вся техника находится у нас в собственности, работают опытные операторы и качественно",
                                  //     maxLines: 3,
                                  //     overflow: TextOverflow.ellipsis,
                                  //     style: TextStyle(
                                  //         color: ColorComponent.gray['600'],
                                  //         fontSize: 13))
                                ],
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 6),
                  ShowStickersList(data: widget.stickers),
                  const Divider(height: 10),
                  Divider(height: 1, color: ColorComponent.gray['100']),
                  const Divider(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/pin.svg',
                                color: ColorComponent.gray["400"], width: 16),
                            const SizedBox(width: 4),
                            Text(data['city']['title'],
                                style: TextStyle(
                                    color: ColorComponent.gray["500"],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                            const Divider(indent: 15),
                            Text(formattedDate(data['created_at']),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: ColorComponent.gray["500"])),
                            const Divider(indent: 15),
                            SvgPicture.asset(
                              'assets/icons/eye.svg',
                              width: 16,
                              color: ColorComponent.gray["400"],
                            ),
                            const Divider(indent: 4),
                            Text(
                              numberFormat(data['statistics']['viewed']),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: ColorComponent.gray["500"]),
                            ),
                          ],
                        ),
                        widget.package?['promotions'] == null
                            ? Row(
                                children: promotions.map((value) {
                                if (value['active'] ?? false) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: SvgPicture.network(value['icon']),
                                  );
                                } else {
                                  return Container();
                                }
                              }).toList())
                            : Row(
                                children: promotions.map((value) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child:
                                      SvgPicture.network(value?['icon'] ?? ""),
                                );
                              }).toList())
                      ],
                    ),
                  ),
                  Divider(height: 5)
                ],
              ),
            ),
          );
  }
}

String formattedDate(isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
  return formattedDate;
}
