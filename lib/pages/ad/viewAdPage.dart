import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/button/favoriteButton.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/image/slider/sliderImageWidget.dart';
import 'package:gservice5/component/stickers/showStickersList.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:intl/intl.dart';

class ViewAdPage extends StatefulWidget {
  final int id;
  const ViewAdPage({super.key, required this.id});

  @override
  State<ViewAdPage> createState() => _ViewAdPageState();
}

class _ViewAdPageState extends State<ViewAdPage> {
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
                Text("Гусеничный экскаватор JCB JS 205NLC (ГАБАРИТНЫЙ)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    maxLines: 1),
                Text(priceFormat(20000000),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        "Гусеничный экскаватор JCB JS 205NLC (ГАБАРИТНЫЙ)",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(priceFormat(20000000),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
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
                        Divider(indent: 8),
                        Container(
                          height: 24,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorComponent.red["600"],
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            "Хит продаж",
                            style: TextStyle(
                                height: 1,
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Divider(indent: 8),
                        SvgPicture.asset('assets/icons/fire.svg'),
                        Divider(indent: 8),
                        SvgPicture.asset('assets/icons/badgeCheck.svg')
                      ],
                    ),
                    const SizedBox(height: 8),
                    const ShowStickersList(),
                  ],
                ),
              ),
              const SliderImageWidget(images: [
                "https://images.unsplash.com/photo-1481555716071-8830d3e254ba?q=80&w=2157&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1481555716071-8830d3e254ba?q=80&w=2157&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1481555716071-8830d3e254ba?q=80&w=2157&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
              ]),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text("15 Сентябрь 2024, 04:20",
                          style: TextStyle(
                              color: ColorComponent.gray["500"], fontSize: 12)),
                    ),
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/location.svg',
                        color: ColorComponent.gray["500"], width: 16),
                    const SizedBox(width: 4),
                    Text("г. Алматы",
                        style: TextStyle(
                            color: ColorComponent.gray["500"],
                            fontSize: 12,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Divider(
                  color: ColorComponent.gray["200"], indent: 15, endIndent: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(children: [
                        Expanded(child: Text("Модель: ")),
                        Expanded(
                            child: Text("МТЗ Белорус",
                                style: TextStyle(fontWeight: FontWeight.w600)))
                      ]),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(children: [
                        Expanded(child: Text("Модель: ")),
                        Expanded(
                            child: Text("МТЗ Белорус",
                                style: TextStyle(fontWeight: FontWeight.w600)))
                      ]),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(children: [
                        Expanded(child: Text("Модель:")),
                        SizedBox(width: 6),
                        Expanded(
                            child: Text("МТЗ Белорус",
                                style: TextStyle(fontWeight: FontWeight.w600)))
                      ]),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                        "Одно из неплохих определений сельскохозяйственного робота или агро-робота: машина, которая использует аппаратное и программное обеспечение для восприятия окружающей среды, анализа полученных данных о сельскохозяйственных культурах и",
                        style: TextStyle(height: 1.6)),
                    Divider(
                      color: ColorComponent.gray["200"],
                    ),
                    // AuthorAdWidget()
                  ],
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
