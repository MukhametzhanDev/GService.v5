import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/bar/bottomBar/contactBottomBarWidget.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/favoriteButton.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/date/formattedDate.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/image/slider/sliderImageWidget.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/author/authorAdWidget.dart';
import 'package:gservice5/component/widgets/characteristic/showCharacteristicWidget.dart';
import 'package:gservice5/pages/application/document/showDocumentWidget.dart';
import 'package:gservice5/pages/application/document/sliderApplicationSmallImageWidget.dart';
import 'package:gservice5/pages/application/list/recommendationApplicationList.dart';

class ViewApplicationPage extends StatefulWidget {
  final int id;
  const ViewApplicationPage({super.key, required this.id});

  @override
  State<ViewApplicationPage> createState() => _ViewApplicationPageState();
}

class _ViewApplicationPageState extends State<ViewApplicationPage> {
  final ScrollController scrollController = ScrollController();
  Map data = {};
  List images = [];

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
                    FavoriteButton(
                        id: widget.id,
                        active: data['is_favorite'],
                        type: "application"),
                    Divider(indent: 15)
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
                                style: TextStyle(
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
                            Text("Описание",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Divider(height: 12),
                            Text(data['description'],
                                style: TextStyle(height: 1.6)),
                            Divider(indent: 12),
                            Divider(height: 1, color: Color(0xfff4f5f7)),
                          ],
                        ),
                      ),
                      SliderApplicationSmallImageWidget(images: images),
                      Divider(indent: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ShowDocumentWidget(),
                            // Divider(indent: 16),
                            SizedBox(
                              height: 41,
                              child: Button(
                                  onPressed: () {
                                    print(images.length);
                                  },
                                  backgroundColor:
                                      ColorComponent.mainColor.withOpacity(.1),
                                  icon: "alert.svg",
                                  title: "Пожаловаться на заявки"),
                            ),
                            Divider(indent: 16),
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
                            Divider(indent: 16),
                            AuthorAdWidget(
                                title: "Заказчик", data: data['author']),
                            Divider(height: 1, color: Color(0xfff4f5f7)),
                            Divider(height: 12),
                          ],
                        ),
                      ),
                      RecommendationApplicationList(),
                    ],
                  ),
                ),
              ]),
        bottomNavigationBar: data.isEmpty
            ? null
            : ContactBottomBarWidget(hasAd: false, id: data['id']));
  }
}
