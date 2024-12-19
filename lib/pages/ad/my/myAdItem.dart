import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/date/formattedDate.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/price/priceTextWidget.dart';
import 'package:gservice5/pages/ad/my/statistic/statisticAdPage.dart';
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

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white,
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
                          Container(
                            decoration: BoxDecoration(
                                color: ColorComponent.mainColor.withOpacity(.2),
                                borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.5, horizontal: 7),
                            child: Text(
                              data['category']['title'],
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
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
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            role == "individual"
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    height: 36,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1, color: ColorComponent.mainColor)),
                    child: Button(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StatisticAdPage(id: data['id'])));
                        },
                        title: "Статистика",
                        icon: "charTmixeDoutline.svg",
                        backgroundColor: Colors.white),
                  ),
            // Row(
            //   children: [
            //     Container(
            //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(6),
            //           color: ColorComponent.blue['500']),
            //       child: Text("PREMIUM",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.w600,
            //               fontSize: 12)),
            //     ),
            //     Divider(indent: 12),
            //     Text("Активен с 12 Октября",
            //         style: TextStyle(
            //             color: ColorComponent.gray['500'], fontSize: 13))
            //   ],
            // ),
            // const SizedBox(height: 16),
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
                                title: "Поднять в ТОП"),
                          ),
                        ),
                        // Expanded(
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       showListPromotionPage(data);
                        //     },
                        //     child: Container(
                        //       height: 40,
                        //       alignment: Alignment.center,
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(8),
                        //           color: ColorComponent.mainColor),
                        //       child: const Text("Поднять в ТОП",
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.w700, fontSize: 15)),
                        //     ),
                        //   ),
                        // ),
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
                        // GestureDetector(
                        //   child: Container(
                        //     width: 32,
                        //     height: 32,
                        //     alignment: Alignment.center,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(7),
                        //         color: ColorComponent.blue['100']),
                        //     child: SvgPicture.asset('assets/icons/pen.svg'),
                        //   ),
                        // ),
                        // const SizedBox(width: 8),
                        // GestureDetector(
                        //   child: Container(
                        //     width: 32,
                        //     height: 32,
                        //     alignment: Alignment.center,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(7),
                        //         color: ColorComponent.red['100']),
                        //     child: SvgPicture.asset('assets/icons/trash.svg'),
                        //   ),
                        // )
                        // GestureDetector(
                        //   onTap: () {
                        //     showOptions(data);
                        //   },
                        //   child: Container(
                        //     height: 40,
                        //     padding: const EdgeInsets.symmetric(horizontal: 8),
                        //     child: Row(
                        //       children: [
                        //         Text(
                        //           "Править",
                        //           style: TextStyle(
                        //               color: ColorComponent.gray['500'],
                        //               fontSize: 15,
                        //               fontWeight: FontWeight.w500),
                        //         ),
                        //         const SizedBox(width: 12),
                        //         SvgPicture.asset('assets/icons/dotsHorizontal.svg',
                        //             width: 16)
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ]),
            const SizedBox(height: 14),
            Divider(height: 1, color: ColorComponent.gray['100']),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/pinOutline.svg'),
                    const SizedBox(width: 4),
                    Text(data['city']['title'],
                        style: TextStyle(
                            color: ColorComponent.gray['500'],
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                Text(formattedDate(data['created_at'], "dd MMMM HH:mm"),
                    // data['city']['title'],
                    style: TextStyle(
                        color: ColorComponent.gray['500'],
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/eye.svg'),
                    const SizedBox(width: 4),
                    Text(data['statistics']['viewed'].toString(),
                        // data['city']['title'],
                        style: TextStyle(
                            color: ColorComponent.gray['500'],
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/phone.svg',
                        width: 16, color: ColorComponent.gray['500']),
                    const SizedBox(width: 4),
                    Text(data['statistics']['called'].toString(),
                        // data['city']['title'],
                        style: TextStyle(
                            color: ColorComponent.gray['500'],
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            )
          ])),
    );
  }
}
