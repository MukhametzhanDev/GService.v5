import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/favoriteButton.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/modal/contact/shortContactModal.dart';
import 'package:gservice5/component/stickers/showStickersList.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/price/priceTextWidget.dart';
import 'package:gservice5/pages/ad/item/adItemCharacteristic.dart';
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

  void verifyFavoriteAd(value) {
    bool active = FavoriteAdData.adFavorite.containsKey(widget.data['id']);
    widget.data['is_favorite'] = active;
    setState(() {});
  }

  Color getColor() {
    List promotions = widget.data['ad_promotions'];
    if (promotions.isEmpty) {
      return Colors.white;
    } else {
      if (promotions.last['type'] == "color") {
        return Color(int.parse(promotions.last['value'])).withOpacity(.1);
      } else {
        return Colors.white;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = 120.0;
    return GestureDetector(
        onTap: () {
          showAdPage(widget.data['id']);
        },
        onLongPress: () => onLongPressShowNumber(widget.data, context),
        child: Container(
          decoration: BoxDecoration(
              color: getColor(),
              border: const Border(
                  bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(widget.data['title'] ?? "",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: ColorComponent.blue['700']),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 16),
                  widget.showCategory
                      ? Container(
                          height: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorComponent.mainColor,
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(widget.data['category']['title'],
                              style: const TextStyle(
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
              const Divider(height: 8),
              PriceTextWidget(prices: widget.data['prices'], fontSize: 15),
              const Divider(height: 12),
              Container(
                constraints: BoxConstraints(maxHeight: imageHeight),
                child: Row(
                  children: [
                    widget.data['images'].isEmpty ||
                            widget.data['images'] == null
                        ? Container()
                        : SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            height: imageHeight,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: CacheImage(
                                      url: widget.data['images'][0],
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      height: imageHeight,
                                      borderRadius: 8),
                                ),
                                // Positioned(
                                //   top: 8,
                                //   left: 8,
                                //   child: ClipRRect(
                                //     child: BackdropFilter(
                                //       filter:
                                //           ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //             color: Colors.white.withOpacity(.7),
                                //             borderRadius: BorderRadius.circular(4)),
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
                                //                     fontWeight: FontWeight.w600,
                                //                     color:
                                //                         ColorComponent.blue['500']))
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(widget.data['sub_title'],
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 1.3),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const Divider(height: 8),
                        Expanded(
                            child: AdItemCharacteristic(data: widget.data)),
                        // Text(
                        //     "На заказы от 3-х смен мы предоставляем скидку. Вся техника находится у нас в собственности, работают опытные операторы и качественно",
                        //     maxLines: 3,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: TextStyle(
                        //         color: ColorComponent.gray['600'],
                        //         fontSize: 13))
                      ],
                    )),
                  ],
                ),
              ),
              const Divider(height: 3),
              ShowStickersList(data: widget.data['stickers']),
              const Divider(height: 10),
              Divider(height: 1, color: ColorComponent.gray['200']),
              const Divider(height: 10),
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
                      const Divider(indent: 15),
                      Text(formattedDate(widget.data['created_at']),
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
                        numberFormat(widget.data['statistics']['viewed']),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorComponent.gray["500"]),
                      ),
                    ],
                  ),
                  ShowPackageIcons(data: widget.data['ad_promotions'])
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
