import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/my/myAdListWidget.dart';
import 'package:gservice5/pages/ad/my/statusAd/statusAdsWidget.dart';

class MyAdListPage extends StatefulWidget {
  const MyAdListPage({super.key});

  @override
  State<MyAdListPage> createState() => _MyAdListPageState();
}

class _MyAdListPageState extends State<MyAdListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackTitleButton(title: "Мои объявление"), leadingWidth: 200),
      body: Column(
        children: [
          const StatusAdsWidget(),
          Container(
              height: 1,
              color: ColorComponent.gray['100'],
              margin: const EdgeInsets.only(top: 10)),
          const Expanded(child: MyAdListWidget())
        ],
      ),
    );
  }
}
