import 'package:flutter/material.dart';
import 'package:gservice5/component/appBar/leadingLogo.dart';
import 'package:gservice5/component/banner/bannersList.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/menuButton.dart';
import 'package:gservice5/component/button/searchButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/main/rubricMainButtons.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: LeadingLogo(),
          leadingWidth: 156,
          actions: [MenuButton(), Divider(indent: 15)],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Divider(indent: 16),
          BannersList(),
          Divider(indent: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
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
                        onPressed: () {}, title: "Показать 12 000 объявлений")),
                Divider(indent: 16),
                RubricMainButtons()
              ],
            ),
          )
        ])));
  }
}
