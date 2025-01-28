import 'dart:ui';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/favoriteAdButton.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/modal/contact/shortContactModal.dart';
import 'package:gservice5/component/stickers/showStickersList.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/price/priceTextWidget.dart';
import 'package:gservice5/pages/ad/item/adItemCharacteristic.dart';
import 'package:gservice5/pages/ad/package/showPackageIcons.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';

class AdItem extends StatefulWidget {
  final Map data;
  final String? fromPage;
  const AdItem({super.key, required this.data, this.fromPage});

  @override
  State<AdItem> createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
  final analytics = FirebaseAnalytics.instance;

  void showAdPage(int id) {
    context.router.pushNamed("/product/$id");
    // context.router.pushNamed("/ad/$id");
    // Navigator.push(
    // //     context, MaterialPageRoute(builder: (context) => ViewAdPage(id: id)));
    analytics.logSelectContent(
        contentType: GAContentType.ad,
        itemId: id.toString(),
        parameters: {
          GAKey.title: widget.data['title'] ?? '',
          GAKey.screenName: widget.fromPage ?? ''
        }).catchError((e) {
      if (kDebugMode) {
        debugPrint(e);
      }
    });
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
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        FavoriteAdButton(data: widget.data),
                      ],
                    ),
                    PriceTextWidget(
                        prices: widget.data['prices'], fontSize: 15),
                    const Divider(height: 12),
                    Container(
                      padding: const EdgeInsets.only(right: 15),
                      constraints: BoxConstraints(maxHeight: imageHeight),
                      child: Row(
                        children: [
                          widget.data['images'].isEmpty ||
                                  widget.data['images'] == null
                              ? Container()
                              : SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  height: imageHeight,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: CacheImage(
                                            url: widget.data['images'][0],
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.2,
                                            height: imageHeight,
                                            borderRadius: 8),
                                      ),
                                    ],
                                  ),
                                ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.data['sub_title'],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      height: 1.3),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              const Divider(height: 4),
                              Expanded(
                                  child:
                                      AdItemCharacteristic(data: widget.data)),
                            ],
                          )),
                        ],
                      ),
                    ),
                    const Divider(height: 3),
                  ],
                ),
              ),
              ShowStickersList(data: widget.data['stickers']),
              const Divider(height: 10),
              Divider(height: 1, color: ColorComponent.gray['100']),
              const Divider(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
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
