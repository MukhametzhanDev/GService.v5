import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/date/formattedDate.dart';
import 'package:gservice5/component/description/showDescriptionWidget.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/slider/sliderImageWidget.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/statistic/analyticAdWidget.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/component/widgets/characteristic/showCharacteristicWidget.dart';
import 'package:gservice5/component/widgets/price/priceTextWidget.dart';
import 'package:gservice5/pages/ad/my/optionsMyAdModal.dart';
import 'package:gservice5/pages/ad/my/request/myAdRequest.dart';
import 'package:gservice5/pages/ad/my/statistic/statisticAdPage.dart';
import 'package:gservice5/pages/ad/package/listPackagePage.dart';
import 'package:gservice5/pages/ad/widget/viewCharacteristicWidget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ViewMyAdPage extends StatefulWidget {
  final int id;
  const ViewMyAdPage({super.key, required this.id});

  @override
  State<ViewMyAdPage> createState() => _ViewMyAdPageState();
}

class _ViewMyAdPageState extends State<ViewMyAdPage> {
  final ScrollController scrollController = ScrollController();
  Map<String, dynamic> data = {};
  bool loader = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/ad/${widget.id}");
      print(response.data['data']);
      if (response.data['success']) {
        data = response.data['data'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
      print(response.data);
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  Future unZipAd() async {
    if (await MyAdRequest().unZipAd(data['id'], context)) {
      Navigator.pop(context, "update");
    }
  }

  Future restoreAd() async {
    if (await MyAdRequest().restoreAd(data['id'], context)) {
      Navigator.pop(context, "update");
    }
  }

  void showPromotionAdPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListPackagePage(
                categoryId: data['category']['id'],
                adId: data['id'],
                goBack: true)));
  }

  void showOptionsModal(Map<String, dynamic> data) {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) =>
            OptionsMyAdModal(data: data, status: data['status'])).then((value) {
      if (value != null) {
        Navigator.pop(context, value);
      }
    });
  }

  void showStatisticPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => StatisticAdPage(data: data)));
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
                    // FavoriteButton(iconColor: ColorTheme['black_white']),
                    ShareButton(id: widget.id, hasAd: true),
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
                        PriceTextWidget(prices: data['prices'], fontSize: 13)
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

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(data['title'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: ColorComponent.blue['700'],
                                          fontWeight: FontWeight.w600)),
                                ),
                                const Divider(indent: 16),
                                Container(
                                  height: 24,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: ColorComponent.mainColor,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(
                                    data['category']['title'],
                                    style: const TextStyle(
                                        height: 1,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
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
                      SliderImageWidget(images: data['images']),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Divider(indent: 24),
                            const Text("Статистика",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            const Divider(height: 10),
                            AnalyticAdWidget(data: data['statistics']),
                            const Divider(height: 10),
                            Container(
                              height: 40,
                              margin: const EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1,
                                      color: ColorComponent.mainColor)),
                              child: Button(
                                  onPressed: showStatisticPage,
                                  title: "Статистика",
                                  icon: "charTmixeDoutline.svg",
                                  backgroundColor: Colors.white),
                            ),
                            const Divider(height: 16),
                            Divider(
                                height: 1, color: ColorComponent.gray['100']),
                            const Divider(height: 16),
                            const Text("Характеристики",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            const Divider(height: 4),
                            ShowCharacteristicWidget(
                                title: "Город", subTitle: data['city']),
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
                            ViewCharacteristicWidget(
                                characteristics: data['characteristics']),
                            const SizedBox(height: 10),
                            ShowDescriptionWidget(desc: data['description']),
                            const Divider(height: 12),
                            Divider(
                                height: 1, color: ColorComponent.gray['100']),
                            const Divider(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ID: ${data['id']}",
                                    style: TextStyle(
                                        color: ColorComponent.gray["500"],
                                        fontSize: 12)),
                                Text(
                                    formattedDate(
                                        data['created_at'], "dd MMMM yyyy"),
                                    style: TextStyle(
                                        color: ColorComponent.gray["500"],
                                        fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        bottomNavigationBar: loader
            ? null
            : BottomNavigationBarComponent(
                child: data['status'] == "archived"
                    ? Button(
                        onPressed: unZipAd,
                        title: "Разархивировать",
                        backgroundColor: ColorComponent.mainColor,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                      )
                    : data['status'] == "deleted"
                        ? Button(
                            onPressed: restoreAd,
                            title: "Восстановить",
                            backgroundColor: ColorComponent.mainColor,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Button(
                                  onPressed: showPromotionAdPage,
                                  title: "Поднять в ТОП",
                                  backgroundColor: ColorComponent.mainColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showOptionsModal(data);
                                },
                                child: Container(
                                  height: 40,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Править",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: ColorComponent.gray['500']),
                                      ),
                                      const SizedBox(width: 12),
                                      SvgPicture.asset(
                                          'assets/icons/dotsHorizontal.svg',
                                          width: 18)
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15)
                            ],
                          )));
  }
}
