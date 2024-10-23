import 'package:flutter/material.dart';
import 'package:gservice5/component/appBar/leadingLogo.dart';
import 'package:gservice5/component/banner/bannersList.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/menuButton.dart';
import 'package:gservice5/component/button/searchButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/adItem.dart';
import 'package:gservice5/pages/main/applicationListMain.dart';
import 'package:gservice5/pages/main/list/mainListPage.dart';
import 'package:gservice5/pages/main/menu/menuMainModal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MainPage extends StatefulWidget {
  final ScrollController scrollController;
  const MainPage({super.key, required this.scrollController});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //show ad list page
  void showMainListPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainListPage()));
  }

  void showMenuModal() {
    showCupertinoModalBottomSheet(
        context: context, builder: (context) => MenuMainModal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: LeadingLogo(), leadingWidth: 156, actions: [
          MenuButton(onPressed: showMenuModal),
          Divider(indent: 15)
        ]),
        body: SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(children: [
              Divider(indent: 16),
              BannersList(),
              Divider(indent: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchButton(),
                    Divider(indent: 12),
                    SizedBox(
                        height: 40,
                        child: Row(children: [
                          Expanded(
                              child: Button(
                            onPressed: () {},
                            title: "Весь Казахстан",
                            icon: "pin.svg",
                            backgroundColor: ColorComponent.blue['100'],
                            titleColor: ColorComponent.blue['500'],
                          )),
                          Divider(indent: 12),
                          Expanded(
                              child: Button(
                            onPressed: () {},
                            title: "Фильтр",
                            icon: "filter.svg",
                            backgroundColor:
                                ColorComponent.mainColor.withOpacity(.1),
                          ))
                        ])),
                    Divider(indent: 12),
                    SizedBox(
                        height: 40,
                        child: Button(
                            onPressed: showMainListPage,
                            title: "Показать 12 000 объявлений")),
                    Divider(indent: 16),
                  ],
                ),
              ),
              Divider(indent: 20),
              ApplicationListMain(),
              // Divider(height: 6),
              // CompanyListMain(),
              Divider(indent: 15),
              Column(
                  children: List.generate(20, (index) => index).map((value) {
                return AdItem();
              }).toList())
            ])));
  }
}
