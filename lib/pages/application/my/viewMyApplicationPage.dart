import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/map/viewAddressMapWidget.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/application/document/showDocumentWidget.dart';

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
                    // FavoriteButtonComponent(iconColor: ColorTheme['black_white']),
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
                        Text("${priceFormat(data['prices'][0]['original_price'])}  ₸",
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
                            Text(
                                "${priceFormat(data['prices'][0]['original_price'])} ₸",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/pin.svg',
                                        color: ColorComponent.gray["500"],
                                        width: 16),
                                    const SizedBox(width: 4),
                                    Text(data['city']['title'],
                                        style: TextStyle(
                                            color: ColorComponent.gray["500"],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/eye.svg',
                                        color: ColorComponent.gray["500"],
                                        width: 16),
                                    const SizedBox(width: 4),
                                    Text("123 просмотров",
                                        style: TextStyle(
                                            color: ColorComponent.gray["500"],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                            Divider(height: 12),
                            Divider(
                                height: 1, color: ColorComponent.gray['50']),
                            Divider(height: 12),
                            // Text("Характеристики",
                            //     style: TextStyle(
                            //         fontSize: 18, fontWeight: FontWeight.w600)),
                            // const Padding(
                            //   padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                            //   child: Row(children: [
                            //     Expanded(child: Text("Модель: ")),
                            //     Expanded(
                            //         child: Text("МТЗ Белорус",
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.w600)))
                            //   ]),
                            // ),
                            // const Padding(
                            //   padding: EdgeInsets.only(bottom: 8.0),
                            //   child: Row(children: [
                            //     Expanded(child: Text("Модель: ")),
                            //     Expanded(
                            //         child: Text("МТЗ Белорус",
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.w600)))
                            //   ]),
                            // ),
                            // const Padding(
                            //   padding: EdgeInsets.only(bottom: 8.0),
                            //   child: Row(children: [
                            //     Expanded(child: Text("Модель:")),
                            //     SizedBox(width: 6),
                            //     Expanded(
                            //         child: Text("МТЗ Белорус",
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.w600)))
                            //   ]),
                            // ),
                            // const SizedBox(height: 16),
                            Text("Описание",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            Divider(height: 8),
                            Text(data['description'],
                                style: TextStyle(height: 1.6)),
                            Divider(height: 12),
                            Divider(
                                height: 1, color: ColorComponent.gray['50']),
                            Divider(height: 12),
                            ShowDocumentWidget(),
                            Divider(height: 12),
                            Divider(
                                height: 1, color: ColorComponent.gray['50']),
                            Divider(height: 12),

                            // Row(
                            //   children: [
                            //     ClipRRect(
                            //       borderRadius: BorderRadius.circular(2),
                            //       child: SvgPicture.network(
                            //           data['country']['flag'],
                            //           width: 22),
                            //     ),
                            //     Divider(indent: 8),
                            //     Text(data['country']['title'] + ", "),
                            //     Text(data['city']['title']),
                            //     Divider(height: 12),

                            //   ],
                            // )
                            ViewAddressMapWidget(data: data)
                          ],
                        ),
                      ),
                      // RecommendationAdList(),
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
                child:
                    Button(onPressed: deleteData, title: "Отменить заявку"))));
  }
}
