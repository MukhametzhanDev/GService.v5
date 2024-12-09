import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/bar/bottomBar/contactBottomBarWidget.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/date/formattedDate.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/image/slider/sliderImageWidget.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/author/authorAdWidget.dart';
import 'package:gservice5/component/widgets/characteristic/showCharacteristicWidget.dart';
import 'package:gservice5/pages/application/document/showDocumentWidget.dart';
import 'package:gservice5/pages/application/recommendationApplicationList.dart';

class ViewApplicationPage extends StatefulWidget {
  final int id;
  const ViewApplicationPage({super.key, required this.id});

  @override
  State<ViewApplicationPage> createState() => _ViewApplicationPageState();
}

class _ViewApplicationPageState extends State<ViewApplicationPage> {
  final ScrollController scrollController = ScrollController();
  Map data = {};

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/application/${widget.id}");
      if (response.data['success']) {
        data = response.data['data'];
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: data.isEmpty
            ? LoaderComponent()
            : CustomScrollView(controller: scrollController, slivers: [
                SliverAppBar(
                  pinned: true,
                  leading: const BackIconButton(),
                  centerTitle: false,
                  actions: [
                    // FavoriteButtonComponent(iconColor: ColorTheme['black_white']),
                    ShareButton(id: widget.id, hasAd: true),
                    Divider(indent: 10),
                    //  FavoriteButton(),
                    Divider(indent: 15)
                  ],
                  title: FadeOnScroll(
                    scrollController: scrollController,
                    fullOpacityOffset: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Нужен экскаватор 2-ух кубовый",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: ColorComponent.blue['700']),
                            maxLines: 1),
                        Text(priceFormat(0),
                            style: TextStyle(
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
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Нужен экскаватор 2-ух кубовый",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: ColorComponent.blue['700'])),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(priceFormat(data['cost']),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600))),
                                Container(
                                  height: 24,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: ColorComponent.mainColor,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(
                                    data['category']['title'],
                                    style: TextStyle(
                                        height: 1,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      SliderImageWidget(images: data['images']),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(indent: 12),
                            Text("Характеристики",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
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
                            const SizedBox(height: 16),
                            Text("Описание",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Divider(height: 8),
                            Text(data['description'],
                                style: TextStyle(height: 1.6)),
                            Divider(indent: 16),
                            // ShowDocumentWidget(),
                            // Divider(indent: 16),
                            SizedBox(
                              height: 41,
                              child: Button(
                                  onPressed: () {},
                                  backgroundColor:
                                      ColorComponent.mainColor.withOpacity(.1),
                                  icon: "alert.svg",
                                  title: "Пожаловаться на заявки"),
                            ),
                            Divider(indent: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("ID: ${data['id']}",
                                        style: TextStyle(
                                            color: ColorComponent.gray["500"],
                                            fontSize: 12)),
                                    Divider(indent: 16),
                                    Text(
                                        formattedDate(
                                            data['created_at'], "dd MMMM yyyy"),
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
                                        data['statistics']['viewed'].toString(),
                                        style: TextStyle(
                                            color: ColorComponent.gray["500"],
                                            fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                            Divider(indent: 16),
                            AuthorAdWidget(
                                title: "О владельце заявок",
                                data: data['author']),
                            Divider(indent: 16),
                          ],
                        ),
                      ),
                      RecommendationApplicationList(),
                    ],
                  ),
                ),
              ]),
        bottomNavigationBar: data.isEmpty ? null : ContactBottomBarWidget());
  }
}
