import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/statistic/analyticAdItemWidget.dart';
import 'package:gservice5/component/stickers/showStickersList.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/price/priceTextWidget.dart';
import 'package:gservice5/pages/ad/package/showPackageIcons.dart';
import 'package:intl/intl.dart';

class MyAdItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function(int id) onPressed;
  final void Function(Map<String, dynamic> data) showOptions;
  final void Function(Map data) showListPromotionPage;
  final String role;
  const MyAdItem(
      {super.key,
      required this.data,
      required this.onPressed,
      required this.showOptions,
      required this.showListPromotionPage,
      required this.role});

  Color getColor() {
    List promotions = data['ad_promotions'];
    if (promotions.isEmpty) {
      return Colors.white;
    } else {
      if (promotions.last['type'] == "color") {
        return Color(int.parse(promotions.last['value'])).withOpacity(.2);
      } else {
        return Colors.white;
      }
    }
  }

  Widget getExpires() {
    List promotions = data['ad_promotions'];
    if (promotions.isEmpty) {
      return Container();
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: data['stickers'].isEmpty ? 10 : 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                  color: getColor(), borderRadius: BorderRadius.circular(4)),
              child: RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                    TextSpan(
                        text: "Вверх в списке до ",
                        style: TextStyle(color: ColorComponent.gray['700'])),
                    TextSpan(
                        text:
                            formattedDate(promotions.last?['expires_at'] ?? ""),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ])),
            ),
            ShowPackageIcons(data: data['ad_promotions'])
          ],
        ),
      );
    }
  }

  String formattedDate(String dateString) {
    DateTime date;
    if (dateString.isEmpty) {
      date = DateTime.now();
    } else {
      date = DateTime.parse(dateString);
    }
    final String formattedDate = DateFormat('d MMMM', 'ru').format(date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    List promotions = data['ad_promotions'];
    return GestureDetector(
      onTap: () {
        onPressed(data['id']);
      },
      // onLongPress: () {
      //   showOptions(data);
      // },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(
              // color: getColor(),
              border: Border(
                  bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 2),
            Row(
              children: [
                data['images'].isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: CacheImage(
                            url: data['images'][0],
                            // url: data['images'][0]['url'],
                            width: 96,
                            height: 96,
                            borderRadius: 8),
                      ),
                Expanded(
                  child: SizedBox(
                      height: 96,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Divider(height: 8),
                          Text(
                            data['title'],
                            // data['title'],
                            style: TextStyle(
                                color: ColorComponent.blue['500'],
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // const SizedBox(height: 8),
                          PriceTextWidget(prices: data['prices']),
                          Text(
                            data['city']['title'],
                            // data['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox(height: 10),
            getExpires(),
            Padding(
              padding:
                  EdgeInsets.only(bottom: data['stickers'].isEmpty ? 0 : 12.0),
              child: ShowStickersList(data: data['stickers']),
            ),
            data['status'] == "archived"
                ? SizedBox(
                    height: 36,
                    child: Button(
                        onPressed: () {
                          showOptions(data);
                        },
                        title: "Разархивировать"),
                  )
                : data['status'] == "deleted"
                    ? SizedBox(
                        height: 36,
                        child: Button(
                            onPressed: () {
                              showOptions(data);
                            },
                            title: "Восстановить"),
                      )
                    : Row(children: [
                        Expanded(
                            child: SizedBox(
                                height: 36,
                                child: Button(
                                    onPressed: () {
                                      showListPromotionPage(data);
                                    },
                                    title: promotions.isNotEmpty
                                        ? "Продлить пакет"
                                        : "Поднять в ТОП"))),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            showOptions(data);
                          },
                          child: Container(
                              height: 32,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Text("Править",
                                      style: TextStyle(
                                          color: ColorComponent.gray['700'])),
                                  const Divider(indent: 12),
                                  SvgPicture.asset(
                                      'assets/icons/dotsHorizontal.svg')
                                ],
                              )),
                        ),
                      ]),
            const Divider(height: 18),
            const AnalyticAdItemWidget(data: {
              "viewed": 1380,
              "called": 0,
              "favorites": 15,
              "shared": 0,
              "wrote": 0
            }),
          ])),
    );
  }
}
