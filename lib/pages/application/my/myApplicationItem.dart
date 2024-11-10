import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:intl/intl.dart';

class MyApplicationItem extends StatelessWidget {
  final Map data;
  final void Function(int id) onPressed;
  const MyApplicationItem(
      {super.key, required this.data, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffE5E7EB)))),
      child: TextButton(
          onPressed: () {
            onPressed(data['id']);
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
          child: Row(
            children: [
              // data['images'].isEmpty
              //     ? Container()
              //     : Padding(
              //         padding: const EdgeInsets.only(right: 12.0),
              //         child: CacheImage(
              //             url: data['images'][0]['url'],
              //             width: 92,
              //             height: 92,
              //             borderRadius: 8),
              //       ),
              Expanded(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                      ColorComponent.mainColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                data['for_sale'] ?? false
                                    ? "Продажа"
                                    : "Аренда",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.5, horizontal: 5),
                            ),
                            SizedBox(width: 6),
                            SvgPicture.asset('assets/icons/fire.svg'),
                            SizedBox(width: 6),
                            SvgPicture.asset('assets/icons/star.svg',
                                width: 16),
                          ],
                        ),
                      ),
                      Text(priceFormat(data['price']),
                          style: TextStyle(fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                      "Услуги спец техники для сбора урожая с большой командой водителей и специалистов (большие объемы). Работаем в области Алматы и в сторону Балхаша",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(height: 1.5)),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/pinOutline.svg',
                          color: ColorComponent.gray['500'], width: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(data['city']['title'],
                            style: TextStyle(
                                color: ColorComponent.gray['500'],
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(width: 12),
                      Text(formattedDate(data['created_at']),
                          style: TextStyle(
                              color: ColorComponent.gray['500'], fontSize: 12))
                    ],
                  ),
                ],
              ))
            ],
          )),
    );
  }
}

String formattedDate(isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
  return formattedDate;
}
