import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/bar/bottomBar/contactBottomBarWidget.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/favoriteButton.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/description/showDescriptionWidget.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/slider/sliderImageWidget.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/404/notFoundpage.dart';
import 'package:gservice5/pages/create/application/leasing/createApplicationLeasingWidget.dart';
import 'package:gservice5/pages/author/authorAdWidget.dart';
import 'package:gservice5/component/widgets/characteristic/showCharacteristicWidget.dart';
import 'package:gservice5/component/widgets/price/priceTextWidget.dart';
import 'package:gservice5/pages/ad/list/recommendationAdList.dart';
import 'package:gservice5/pages/ad/widget/viewCharacteristicWidget.dart';
import 'package:gservice5/pages/favorite/ad/data/favoriteAdData.dart';
import 'package:intl/intl.dart';

class ViewAdPage extends StatefulWidget {
  final int id;
  const ViewAdPage({super.key, required this.id});

  @override
  State<ViewAdPage> createState() => _ViewAdPageState();
}

class _ViewAdPageState extends State<ViewAdPage> {
  final ScrollController scrollController = ScrollController();
  Map data = {};
  bool loader = true;
  int? statusCode;

  final analytics = GetIt.I<FirebaseAnalytics>();

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/ad/${widget.id}");
      statusCode = response.statusCode;
      if (response.data['success']) {
        data = response.data['data'];
        loader = false;
        addAdFavorite();
        setState(() {});

        await analytics.logViewItem(parameters: {
          GAKey.screenName: GAParams.viewAdPage,
        }, items: [
          AnalyticsEventItem(
            itemId: data['id']?.toString(),
            itemName: data['title'],
            itemListId: GAParams.listFavoriteAdPageListId,
            itemListName: GAParams.listFavoriteAdPageListName,
          )
        ]);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void addAdFavorite() {
    if (data['is_favorite']) {
      FavoriteAdData.adFavorite.addAll({data['id']: ""});
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotFoundPage(
      statusCode: statusCode,
      child: Scaffold(
          body: loader
              ? const LoaderComponent()
              : CustomScrollView(controller: scrollController, slivers: [
                  SliverAppBar(
                    pinned: true,
                    leading: const BackIconButton(),
                    centerTitle: false,
                    actions: [
                      // FavoriteButtonComponent(iconColor: ColorTheme['black_white']),
                      ShareButton(
                        id: widget.id,
                        hasAd: true,
                        frompage: GAParams.viewAdPage,
                      ),
                      const Divider(indent: 10),
                      FavoriteButton(
                        id: data['id'],
                        type: "ad",
                        active: data['is_favorite'],
                        fromPage: GAParams.viewAdPage,
                      ),
                      const Divider(indent: 15)
                    ],
                    title: FadeOnScroll(
                      scrollController: scrollController,
                      fullOpacityOffset: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['title'],
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ColorComponent.blue['700']),
                              maxLines: 1),
                          const Divider(height: 4),
                          PriceTextWidget(prices: data['prices'], fontSize: 14)
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
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
                              Text(data['title'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: ColorComponent.blue['700'],
                                      fontWeight: FontWeight.w600)),
                              const Divider(height: 6),
                              PriceTextWidget(
                                  prices: data['prices'], fontSize: 16),
                              const SizedBox(height: 4),
                              // Row(
                              //   children: [const ShowStickersList()],
                              // ),
                              // Divider(height: 4),
                            ],
                          ),
                        ),
                        SliderImageWidget(
                          images: data['images'],
                          fromPage: GAParams.viewAdPage,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Divider(indent: 24),
                              const Text("Характеристики",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              const Divider(height: 4),
                              ShowCharacteristicWidget(
                                  title: "Город", subTitle: data['city']),
                              ShowCharacteristicWidget(
                                  title: "Тип",
                                  subTitle: data['transport_type']),
                              ShowCharacteristicWidget(
                                  title: "Марка",
                                  subTitle: data['transport_brand']),
                              ShowCharacteristicWidget(
                                  title: "Модель",
                                  subTitle: data['transport_model']),
                              ShowCharacteristicWidget(
                                  title: "Профессия",
                                  subTitle: data['profession']),
                              ShowCharacteristicWidget(
                                  title: "Категория товара",
                                  subTitle: data['spare_part_category']),
                              ShowCharacteristicWidget(
                                  title: "Рубрика товара",
                                  subTitle: data['spare_part_rubric']),
                              ShowCharacteristicWidget(
                                  title: "Производитель",
                                  subTitle: data['spare_part_brand']),
                              ViewCharacteristicWidget(
                                  characteristics: data['characteristics']),
                              const SizedBox(height: 10),
                              ShowDescriptionWidget(desc: data['description']),
                              const Divider(height: 16),
                              const Divider(
                                  height: 1, color: Color(0xfff4f5f7)),
                              const Divider(height: 12),
                              CreateApplicationLeasingWidget(data: data),
                            ],
                          ),
                        ),
                        AuthorAdWidget(
                            fromPage: GAParams.viewAdPage,
                            title: "О владельце объявления",
                            data: data['author'],
                            showOtherAd: true,
                            id: data['id'],
                            subTitle: "Другие объявления продавца",
                            type: "ad"),
                        const Divider(height: 6),
                        const Divider(height: 1, color: Color(0xfff4f5f7)),
                        const Divider(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 41,
                                  child: Button(
                                      onPressed: () {
                                        analytics.logEvent(
                                            name: GAEventName.buttonClick,
                                            parameters: {
                                              GAKey.buttonName:
                                                  GAParams.btnComplain,
                                              GAKey.screenName:
                                                  GAParams.viewAdPage,
                                              GAKey.itemId: widget.id.toString()
                                            }).catchError((e) {
                                          if (kDebugMode) {
                                            debugPrint(e.toString());
                                          }
                                        });
                                      },
                                      backgroundColor: ColorComponent.mainColor
                                          .withOpacity(.1),
                                      icon: "alert.svg",
                                      title: "Пожаловаться на объявление")),
                              const Divider(indent: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("ID: ${data['id']}",
                                          style: TextStyle(
                                              color: ColorComponent.gray["500"],
                                              fontSize: 12)),
                                      const Divider(indent: 16),
                                      Text(formattedDate(data['created_at']),
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
                                      Text(
                                          data['statistics']['viewed']
                                              .toString(),
                                          style: TextStyle(
                                              color: ColorComponent.gray["500"],
                                              fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 14),
                      ],
                    ),
                  ),
                  RecommendationAdList(id: data['id']),
                ]),
          bottomNavigationBar: loader
              ? null
              : ContactBottomBarWidget(
                  id: data['id'],
                  hasAd: true,
                  phones: data['phones'],
                  fromPage: GAParams.viewAdPage,
                )),
    );
  }
}

String formattedDate(isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
  return formattedDate;
}
