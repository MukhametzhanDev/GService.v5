import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/bar/bottomBar/contactBottomBarWidget.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/favoriteButton.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/description/showDescriptionWidget.dart';
import 'package:gservice5/component/image/slider/sliderImageWidget.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/author/authorAdWidget.dart';
import 'package:gservice5/component/widgets/characteristic/showCharacteristicWidget.dart';
import 'package:gservice5/pages/ad/recommendationAdList.dart';

class ViewAdPage2 extends StatefulWidget {
  final int id;
  const ViewAdPage2({super.key, required this.id});

  @override
  State<ViewAdPage2> createState() => _ViewAdPage2State();
}

class _ViewAdPage2State extends State<ViewAdPage2> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(controller: scrollController, slivers: [
          SliverAppBar(
            pinned: true,
            leading: const BackIconButton(),
            centerTitle: false,
            actions: [
              // FavoriteButtonComponent(iconColor: ColorTheme['black_white']),
              ShareButton(id: widget.id, hasAd: true),
              Divider(indent: 10), FavoriteButton(),
              Divider(indent: 15)
            ],
            title: FadeOnScroll(
              scrollController: scrollController,
              fullOpacityOffset: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Экскаватор погрузчик 3CX",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorComponent.blue['700']),
                      maxLines: 1),
                  Divider(height: 4),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                            children: [
                          TextSpan(
                              text: "3 000 ", style: TextStyle(fontSize: 13)),
                          TextSpan(
                              text: "тг./час",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12)),
                        ])),
                    Text(
                      "  |  ",
                      style: TextStyle(
                          color: ColorComponent.gray['300'], fontSize: 13),
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            children: [
                          TextSpan(
                              text: "25 000 ", style: TextStyle(fontSize: 13)),
                          TextSpan(
                              text: "тг./смена",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12)),
                        ]))
                  ]),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // RichText(
                      //     textAlign: TextAlign.start,
                      //     text: TextSpan(
                      //         style: TextStyle(
                      //             fontSize: 20, fontWeight: FontWeight.w600),
                      //         children: [
                      //           TextSpan(
                      //               text: "JCB 3CX ",
                      //               style: TextStyle(color: Colors.black)),
                      //           TextSpan(
                      //               text: "Экскаватор погрузчик",
                      //               style: TextStyle(
                      //                   color: ColorComponent.gray['500'])),
                      //         ])),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Экскаватор погрузчик ",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: ColorComponent.blue['700'],
                                        fontWeight: FontWeight.w600)),
                                Text("JCB 3CX",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: ColorComponent.blue['700'],
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Divider(indent: 16),
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
                        ],
                      ),
                      Divider(height: 6),
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
                            Text(
                              "  |  ",
                              style:
                                  TextStyle(color: ColorComponent.gray['300']),
                            ),
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
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
                                ]))
                          ]),
                      const SizedBox(height: 4),
                      // Row(
                      //   children: [const ShowStickersList()],
                      // ),
                      // Divider(height: 4),
                    ],
                  ),
                ),
                const SliderImageWidget(images: [
                  "https://images.unsplash.com/photo-1603045720438-6897d600529b?q=80&w=1965&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  "https://images.unsplash.com/photo-1597362434494-ed6eb82964ac?q=80&w=2970&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  "https://images.unsplash.com/photo-1481555716071-8830d3e254ba?q=80&w=2157&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  "https://images.unsplash.com/photo-1629934404172-6683955897f1?q=80&w=2970&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  "https://images.unsplash.com/photo-1584186118422-895ef18c418d?q=80&w=2970&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                ]),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Divider(indent: 24),
                      Text("Характеристики",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      Divider(height: 4),
                      Column(
                          children:
                              List.generate(7, (index) => index).map((value) {
                        return ShowCharacteristicWidget(
                            title: "Город", subTitle: "Алматы");
                      }).toList()),
                      Divider(height: 1, color: ColorComponent.gray['50']),
                      const SizedBox(height: 10),
                      ShowDescriptionWidget(),
                      Divider(indent: 16),
                      SizedBox(
                        height: 41,
                        child: Button(
                            onPressed: () {},
                            backgroundColor:
                                ColorComponent.mainColor.withOpacity(.1),
                            icon: "alert.svg",
                            title: "Пожаловаться на объявление"),
                      ),
                      Divider(indent: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("ID: 132",
                                  style: TextStyle(
                                      color: ColorComponent.gray["500"],
                                      fontSize: 12)),
                              Divider(indent: 16),
                              Text("15 Сентябрь 2024",
                                  style: TextStyle(
                                      color: ColorComponent.gray["500"],
                                      fontSize: 12)),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/eye.svg',
                                  color: ColorComponent.gray["500"]),
                              const SizedBox(width: 4),
                              Text("123",
                                  style: TextStyle(
                                      color: ColorComponent.gray["500"],
                                      fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      Divider(height: 14),
                      Divider(height: 1, color: Color(0xfff4f5f7)),
                      Divider(height: 12),
                      AuthorAdWidget(title: "О владельце объявления"),
                      Divider(indent: 16)
                    ],
                  ),
                ),
                RecommendationAdList(),
              ],
            ),
          ),
        ]),
        bottomNavigationBar: ContactBottomBarWidget());
  }
}
