import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/favoriteButton.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/stickers/showStickersList.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/viewAdPage.dart';

class AdItem extends StatefulWidget {
  const AdItem({super.key});

  @override
  State<AdItem> createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
  void showAdPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ViewAdPage(id: 0)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showAdPage,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(width: 1, color: Color(0xfff4f4f4)))),
        // color: ColorComponent.mainColor.withOpacity(.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 24,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: ColorComponent.mainColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          "Аренда",
                          style: TextStyle(
                              height: 1,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Divider(indent: 8),
                      Container(
                        height: 24,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: ColorComponent.red["600"],
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          "Хит продаж",
                          style: TextStyle(
                              height: 1,
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Divider(indent: 8),
                      SvgPicture.asset('assets/icons/fire.svg')
                    ],
                  ),
                  FavoriteButton()
                ],
              ),
            ),
            Divider(indent: 12),
            Row(
              children: [
                CacheImage(
                    url:
                        "https://images.unsplash.com/photo-1631141089933-3dbae5d5c69e?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    width: 120,
                    height: 92,
                    borderRadius: 10),
                Divider(indent: 12),
                SizedBox(
                  height: 92,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(priceFormat(1999999),
                          style: TextStyle(fontSize: 20, height: 1)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: Text(
                          "Гусеничный экскаватор JCB JS 205NLC (ГАБАРИТНЫЙ)",
                          style: TextStyle(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/pin.svg',
                              width: 16, color: Colors.black),
                          Divider(indent: 4),
                          Text(
                            "г. Алматы",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Divider(indent: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: ShowStickersList()),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/eye.svg',
                        width: 16,
                        color: ColorComponent.gray["500"],
                      ),
                      Divider(indent: 4),
                      Text(
                        numberFormat(1200),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ColorComponent.gray["500"]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
