import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/image/slider/sliderImageWidget.dart';
import 'package:gservice5/component/image/slider/smallSliderImageWidget.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/map/viewAddressMapWidget.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/component/widgets/characteristic/showCharacteristicWidget.dart';
import 'package:gservice5/pages/application/document/showDocumentWidget.dart';
import 'package:gservice5/pages/application/my/myApplicationItem.dart';

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
        loader = false;
        setState(() {});
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
            ? LoaderComponent()
            : CustomScrollView(controller: scrollController, slivers: [
                SliverAppBar(
                  pinned: true,
                  leading: const BackIconButton(),
                  centerTitle: false,
                  actions: [
                    ShareButton(id: widget.id, hasAd: true),
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
                                fontSize: 14, fontWeight: FontWeight.w400),
                            maxLines: 1),
                        Text(
                            "${priceFormat(data['prices'][0]['original_price'])}  ₸",
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
                            Text(data['title'],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      "${priceFormat(data['prices'][0]['original_price'])} ₸",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                ),
                                Container(
                                  height: 24,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: ColorComponent.mainColor,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(data['category']['title'],
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            Divider(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("15 Сентябрь 2024, 04:20",
                                    style: TextStyle(
                                        color: ColorComponent.gray["500"],
                                        fontSize: 12)),
                                Divider(indent: 16),
                                SvgPicture.asset('assets/icons/eye.svg',
                                    color: ColorComponent.gray["500"],
                                    width: 16),
                                const SizedBox(width: 4),
                                Text("${data['views']} просмотров",
                                    style: TextStyle(
                                        color: ColorComponent.gray["500"],
                                        fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(height: 12),
                            Divider(
                                height: 1, color: ColorComponent.gray['50']),
                            Divider(height: 8),
                            Text("Характеристики",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Divider(height: 12),
                            ShowCharacteristicWidget(
                                title: "Раздел",
                                subTitle: data['category']['title']),
                            ShowCharacteristicWidget(
                                title: "Тип техники",
                                subTitle: data['transport_type']['title']),
                            ShowCharacteristicWidget(
                                title: "Марка техники",
                                subTitle: data['transport_brand']?['title']),
                            ShowCharacteristicWidget(
                                title: "Модель техники",
                                subTitle: data['transport_model']?['title']),
                            ShowCharacteristicWidget(
                                title: "Профессия",
                                subTitle: data['profession']?['title']),
                            ShowCharacteristicWidget(
                                title: "Город",
                                subTitle: data['city']['title']),
                            ShowCharacteristicWidget(
                                title: "Дата",
                                subTitle: formattedDate(data['created_at'])),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(height: 6),
                            Divider(
                                height: 1, color: ColorComponent.gray['50']),
                            Divider(height: 8),
                            Text("Описание",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Divider(height: 12),
                            Text(data['description'],
                                style: TextStyle(height: 1.6)),
                          ],
                        ),
                      ),
                      SmallSliderImageWidget(images: data['images']),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Divider(height: 12),
                            Divider(
                                height: 1, color: ColorComponent.gray['50']),
                            Divider(height: 12),
                            ViewAddressMapWidget(data: data)
                          ],
                        ),
                      ),
                      Divider(),
                      Divider(height: 1, color: ColorComponent.gray['50']),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("15 Сентябрь 2024, 04:20",
                                style: TextStyle(
                                    color: ColorComponent.gray["500"],
                                    fontSize: 12)),
                            Text("ID 132",
                                style: TextStyle(
                                    color: ColorComponent.gray["500"],
                                    fontSize: 12)),
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
                  title: "Отменить заявку",
                  backgroundColor: ColorComponent.red['100'],
                  titleColor: ColorComponent.red['600'],
                ))));
  }
}
