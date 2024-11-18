import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class MyAdItem extends StatelessWidget {
  final Map data;
  final void Function(int id) onPressed;
  final void Function(Map data) showOptions;
  final void Function(Map data) showListPromotionPage;
  const MyAdItem(
      {super.key,
      required this.data,
      required this.onPressed,
      required this.showOptions,
      required this.showListPromotionPage});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
        child: TextButton(
            onPressed: () {
              onPressed(data['id']);
            },
            style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  CacheImage(
                      url:
                          "https://images.unsplash.com/photo-1527847263472-aa5338d178b8?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dHJhY3RvcnxlbnwwfHwwfHx8MA%3D%3D",
                      // url: data['images'][0]['url'],
                      width: 90,
                      height: 90,
                      borderRadius: 8),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: ColorComponent.mainColor.withOpacity(.2),
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          "Аренда",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.5, horizontal: 7),
                      ),
                      Divider(height: 8),
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
                      const SizedBox(height: 8),
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
              const SizedBox(height: 12),
              Divider(height: 1, color: ColorComponent.gray['100']),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoStatistical("eye.svg", 123),
                  InfoStatistical("message.svg", 123),
                  InfoStatistical("phone.svg", 123),
                  InfoStatistical("heartOutline.svg", 123),
                  InfoStatistical("share.svg", 123),
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
                  Text("Активен с 12 Октября 2024",
                      style: TextStyle(
                          color: ColorComponent.gray['500'], fontSize: 13))
                ],
              ),
              const SizedBox(height: 16),
              // data['status'] == "archived"
              //     ? GestureDetector(
              //         onTap: () {
              //           showOptions(data);
              //         },
              //         child: Container(
              //           height: 40,
              //           alignment: Alignment.center,
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(8),
              //               color: ColorComponent.mainColor),
              //           child: const Text(
              //             "Разархивировать",
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.w700,
              //                 fontSize: 15),
              //           ),
              //         ),
              //       )
              //     : data['status'] == "deleted"
              //         ? GestureDetector(
              //             onTap: () {
              //               showOptions(data);
              //             },
              //             child: Container(
              //               height: 40,
              //               alignment: Alignment.center,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(8),
              //                   color: ColorComponent.mainColor),
              //               child: const Text(
              //                 "Восстановить",
              //                 style: TextStyle(
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w700,
              //                     fontSize: 15),
              //               ),
              //             ),
              //           )
              //         :
              Row(children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
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
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Text(
                          "Править",
                          style: TextStyle(
                              color: ColorComponent.gray['500'],
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 12),
                        SvgPicture.asset('assets/icons/dotsHorizontal.svg',
                            width: 16)
                      ],
                    ),
                  ),
                )
              ]),
              const SizedBox(height: 14),
              Divider(height: 1, color: ColorComponent.gray['100']),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/pinOutline.svg'),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text("Алматы",
                              // data['city']['title'],
                              style: TextStyle(
                                  color: ColorComponent.gray['500'],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text("12.12.1212",
                      // formattedDate(data['created_at']),
                      style: TextStyle(
                          color: ColorComponent.gray['500'], fontSize: 12))
                ],
              )
            ])));
  }

  Widget InfoStatistical(String icon, int count) {
    return Row(
      children: [
        Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: ColorComponent.mainColor.withOpacity(.1)),
            child: SvgPicture.asset("assets/icons/$icon",
                width: 20, height: 20, color: Colors.black)),
        const SizedBox(width: 8),
        Text(
          priceFormat(count),
          // NumberFormat.currency(locale: 'kk', symbol: '')
          //     .format(data['statistics']['shared'])
          //     .toString()
          //     .split(',')[0],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
