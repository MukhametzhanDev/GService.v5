import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:intl/intl.dart';

class MyAdItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function(int id) onPressed;
  final void Function(Map<String, dynamic> data) showOptions;
  final void Function(Map data) showListPromotionPage;
  const MyAdItem(
      {super.key,
      required this.data,
      required this.onPressed,
      required this.showOptions,
      required this.showListPromotionPage});

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
          decoration: BoxDecoration(
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
                SizedBox(
                    height: 96,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: ColorComponent.mainColor.withOpacity(.2),
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            data['category']['title'],
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.5, horizontal: 7),
                        ),
                        // Divider(height: 8),
                        Text(
                          "Трактор МТЗ Беларус-742.7",
                          // data['title'],
                          style: TextStyle(
                              color: ColorComponent.blue['500'],
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // const SizedBox(height: 8),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                      children: [
                                    TextSpan(
                                        text: "3 000 ",
                                        style: TextStyle(fontSize: 15)),
                                    TextSpan(
                                        text: "тг./час",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14)),
                                  ])),
                              Text("  |  "),
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      children: [
                                    TextSpan(
                                        text: "25 000 ",
                                        style: TextStyle(fontSize: 15)),
                                    TextSpan(
                                        text: "тг./смена",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14)),
                                  ])),
                            ]),
                      ],
                    )),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: ColorComponent.blue['500']),
                  child: Text("PREMIUM",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                ),
                Divider(indent: 12),
                Text("Активен с 12 Октября",
                    style: TextStyle(
                        color: ColorComponent.gray['500'], fontSize: 13))
              ],
            ),
            const SizedBox(height: 16),
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
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Text("Править",
                                      style: TextStyle(
                                          color: ColorComponent.gray['700'])),
                                  Divider(indent: 12),
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
                Text(formattedDate(data['created_at']),
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

String formattedDate(isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  String formattedDate = DateFormat('dd MMMM HH:mm ').format(dateTime);
  return formattedDate;
}
