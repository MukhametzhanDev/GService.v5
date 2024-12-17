import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/favoriteButton.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/modal/contact/shortContactModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/price/priceTextWidget.dart';
import 'package:gservice5/pages/ad/package/showPackageIcons.dart';
import 'package:gservice5/pages/ad/viewAdPage.dart';
import 'package:gservice5/pages/favorite/ad/data/favoriteAdData.dart';
import 'package:intl/intl.dart';

class AdItem extends StatefulWidget {
  final Map data;
  final bool showCategory;
  const AdItem({super.key, required this.data, required this.showCategory});

  @override
  State<AdItem> createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
  void showAdPage(int id) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewAdPage(id: id)))
        .then(verifyFavoriteAd);
  }

  String getTitle(value) {
    if (value['values']['title'].runtimeType == String) {
      if (value['values']['title'].length > 3) {
        return value['values']['title'];
      } else {
        return "${value['characteristic']['title']}: ${value['values']['title'].toString().toLowerCase()}";
      }
    } else if (value['values']['title'].runtimeType == int) {
      return value['values']['title'].toString();
    } else {
      return "";
    }
  }

  Widget getCharacteristic(List data) {
    return Wrap(
      children: [
        Wrap(
            children: data.map((value) {
          int index = data.indexOf(value);
          bool last = index == data.length - 1;
          String title = getTitle(value);
          if (title.length > 3) {
            return RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 13, height: 1.4),
                  children: [
                    TextSpan(
                        text: title,
                        style: TextStyle(color: ColorComponent.gray['700'])),
                    TextSpan(
                        text: last ? "." : " / ",
                        style: TextStyle(
                            color: last
                                ? Colors.black
                                : ColorComponent.gray['300']))
                  ]),
            );
          } else {
            return Container();
          }
        }).toList()),
        Text(
            "Прицеп 105 кубов в отличном состоянии тент крыша новая хадовка отличная все делал месяц назад.",
            style: TextStyle(
                fontSize: 13, height: 1.4, color: ColorComponent.gray['700']),
            maxLines: 2,
            overflow: TextOverflow.ellipsis)
      ],
    );
    // RichText(
    //     maxLines: 3,
    //     overflow: TextOverflow.ellipsis,
    //     text: TextSpan(
    //         style: TextStyle(
    //             color: ColorComponent.gray['500'], fontSize: 13, height: 1.4),
    //         children: data.map((value) {
    //           int index = data.indexOf(value);
    //           String slash = data.length - 1 == index ? "." : ", ";
    //           String title =
    //               value['characteristic']['title'].toString().split("/")[0];
    //           return TextSpan(
    //               text:
    //                   "${value['values']['title']}$slash ");
    //         }).toList()));
    // // return "";
  }

  void verifyFavoriteAd(value) {
    bool active = FavoriteAdData.adFavorite.containsKey(widget.data['id']);
    widget.data['is_favorite'] = active;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double IMAGE_HEIGHT = 120.0;
    return GestureDetector(
        onTap: () {
          showAdPage(widget.data['id']);
        },
        onLongPress: () => onLongPressShowNumber(widget.data, context),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.data['title'] ?? "",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ColorComponent.blue['700']),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 16),
                  widget.showCategory
                      ? Container(
                          height: 24,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorComponent.mainColor,
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(widget.data['category']['title'],
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)))
                      : FavoriteButton(
                          id: widget.data['id'],
                          type: "ad",
                          active: widget.data['is_favorite']),
                  // Row(
                  // children: [
                  // Divider(indent: 8),
                  // FavoriteButton()
                  //  ],
                  //  )
                ],
              ),
              Divider(height: 8),
              PriceTextWidget(prices: widget.data['prices'], fontSize: 15),
              Divider(height: 12),
              SizedBox(
                height: IMAGE_HEIGHT,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      height: IMAGE_HEIGHT,
                      child: Stack(
                        children: [
                          CacheImage(
                              url: widget.data['images'][0],
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: IMAGE_HEIGHT,
                              borderRadius: 8),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.7),
                                      borderRadius: BorderRadius.circular(4)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/badgeCheck.svg',
                                          width: 16),
                                      Divider(indent: 4),
                                      Text("От диллера",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  ColorComponent.blue['500']))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(indent: 12),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(widget.data['sub_title'],
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 1.3),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        // Divider(height: 10),
                        getCharacteristic(widget.data['characteristics']),
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
              Divider(height: 6),
              // ShowStickersList(),
              Divider(height: 10),
              Divider(height: 1, color: ColorComponent.gray['100']),
              Divider(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/pin.svg',
                          color: ColorComponent.gray["400"], width: 16),
                      const SizedBox(width: 4),
                      Text(widget.data['city']['title'],
                          style: TextStyle(
                              color: ColorComponent.gray["500"],
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                      Divider(indent: 15),
                      Text(formattedDate(widget.data['created_at']),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: ColorComponent.gray["500"])),
                      Divider(indent: 15),
                      SvgPicture.asset(
                        'assets/icons/eye.svg',
                        width: 16,
                        color: ColorComponent.gray["400"],
                      ),
                      Divider(indent: 4),
                      Text(
                        numberFormat(widget.data['statistics']['viewed']),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorComponent.gray["500"]),
                      ),
                    ],
                  ),
                  ShowPackageIcons()
                ],
              ),
            ],
          ),
        ));
  }
}

String formattedDate(isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  String formattedDate = DateFormat('dd MMMM').format(dateTime);
  return formattedDate;
}
