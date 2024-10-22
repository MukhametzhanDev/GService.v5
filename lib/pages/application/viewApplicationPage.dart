import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/bar/bottomBar/contactBottomBarWidget.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/favoriteButton.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/image/slider/sliderImageWidget.dart';
import 'package:gservice5/component/stickers/showStickersList.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/author/authorAdWidget.dart';
import 'package:gservice5/pages/ad/recommendationAdList.dart';
import 'package:gservice5/pages/application/document/showDocumentWidget.dart';

class ViewApplicationPage extends StatefulWidget {
  final int id;
  const ViewApplicationPage({super.key, required this.id});

  @override
  State<ViewApplicationPage> createState() => _ViewApplicationPageState();
}

class _ViewApplicationPageState extends State<ViewApplicationPage> {
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
            // leading: const BackIconButton(),
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
                  Text("Нужен экскаватор 2-ух кубовый",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      maxLines: 1),
                  Text(priceFormat(0),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                      const Text("Нужен экскаватор 2-ух кубовый",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(priceFormat(0),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        height: 24,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                            color: ColorComponent.mainColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          "Заявки",
                          style: TextStyle(
                              height: 1,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
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
                                  color: ColorComponent.gray["500"], width: 16),
                              const SizedBox(width: 4),
                              Text("г. Алматы",
                                  style: TextStyle(
                                      color: ColorComponent.gray["500"],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/eye.svg',
                                  color: ColorComponent.gray["500"], width: 16),
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
                      Divider(indent: 24),
                      Text("Характеристики",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                        child: Row(children: [
                          Expanded(child: Text("Модель: ")),
                          Expanded(
                              child: Text("МТЗ Белорус",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)))
                        ]),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Row(children: [
                          Expanded(child: Text("Модель: ")),
                          Expanded(
                              child: Text("МТЗ Белорус",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)))
                        ]),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Row(children: [
                          Expanded(child: Text("Модель:")),
                          SizedBox(width: 6),
                          Expanded(
                              child: Text("МТЗ Белорус",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)))
                        ]),
                      ),
                      const SizedBox(height: 16),
                      Text("Описание",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      Divider(height: 8),
                      const Text(
                          "Одно из неплохих определений сельскохозяйственного робота или агро-робота: машина, которая использует аппаратное и программное обеспечение для восприятия окружающей среды, анализа полученных данных о сельскохозяйственных культурах и",
                          style: TextStyle(height: 1.6)),
                      Divider(indent: 16),
                      ShowDocumentWidget(),
                      Divider(indent: 16),
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
                      AuthorAdWidget(title: "О владельце заявок"),
                      Divider(indent: 16),
                    ],
                  ),
                ),
                RecommendationAdList(),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("15 Сентябрь 2024, 04:20",
                          style: TextStyle(
                              color: ColorComponent.gray["500"], fontSize: 12)),
                      Text("ID 132",
                          style: TextStyle(
                              color: ColorComponent.gray["500"], fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
        bottomNavigationBar: ContactBottomBarWidget());
  }
}
