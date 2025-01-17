import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/date/formattedDate.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/component/widgets/characteristic/showCharacteristicWidget.dart';
import 'package:gservice5/pages/application/document/sliderApplicationSmallImageWidget.dart';

class ViewMyApplicationPage extends StatefulWidget {
  final int id;
  const ViewMyApplicationPage({super.key, required this.id});

  @override
  State<ViewMyApplicationPage> createState() => _ViewMyApplicationPageState();
}

class _ViewMyApplicationPageState extends State<ViewMyApplicationPage> {
  final ScrollController scrollController = ScrollController();
  Map data = {};
  bool loader = true;
  List images = [];

  final analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/application/${widget.id}");
      if (response.data['success']) {
        images = response.data['data']['images'];
        data = response.data['data'];
        loader = false;
        setState(() {});

        analytics.logViewItem(items: [
          AnalyticsEventItem(
              itemListId: GAParams.listMyApplicationId,
              itemId: widget.id.toString(),
              itemName: data['title'])
        ]).catchError((e) {
          if (kDebugMode) {
            debugPrint(e.toString());
          }
        });
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  Future deleteData() async {
    try {
      showModalLoader(context);
      Response response = await dio.delete("/application/${widget.id}");
      Navigator.pop(context);
      if (response.data['success']) {
        Navigator.pop(context, "delete");
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }

    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.btnMyApplicationOrderCancel,
      GAKey.screenName: GAParams.viewMyApplicationPage
    }).catchError((e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      frompage: GAParams.viewMyApplicationPage,
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
                                fontWeight: FontWeight.w400,
                                color: ColorComponent.blue['700']),
                            maxLines: 1),
                        Text(priceFormat(0),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            maxLines: 1),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['title'],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: ColorComponent.blue['700'])),
                            const SizedBox(height: 8),
                            Text(priceFormat(data['cost']),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      // SliderImageWidget(images: data['images']),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Divider(indent: 12),
                            ShowCharacteristicWidget(
                                title: "Город", subTitle: data['city']),
                            ShowCharacteristicWidget(
                                title: "Раздел", subTitle: data['category']),
                            ShowCharacteristicWidget(
                                title: "Тип", subTitle: data['transport_type']),
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
                            ShowCharacteristicWidget(
                                title: "Опубликовано",
                                subTitle: {
                                  "title": formattedDate(
                                      data['created_at'], "dd MMMM yyyy")
                                }),
                            const SizedBox(height: 16),
                            const Text("Описание",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            const Divider(height: 12),
                            Text(data['description'],
                                style: const TextStyle(height: 1.6)),
                            const Divider(indent: 12),
                            const Divider(height: 1, color: Color(0xfff4f5f7)),
                          ],
                        ),
                      ),
                      SliderApplicationSmallImageWidget(images: images),
                      const Divider(indent: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ShowDocumentWidget(),
                            // Divider(indent: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ID: ${data['id']}",
                                    style: TextStyle(
                                        color: ColorComponent.gray["500"],
                                        fontSize: 12)),
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/eye.svg',
                                        color: ColorComponent.gray["500"]),
                                    const SizedBox(width: 4),
                                    Text(
                                        data['statistics']['viewed'].toString(),
                                        style: TextStyle(
                                            color: ColorComponent.gray["500"],
                                            fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(indent: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Button(
                  onPressed: deleteData,
                  title: "Отменить заказ",
                  backgroundColor: ColorComponent.red['100'],
                  titleColor: ColorComponent.red['600'],
                ))));
  }
}
