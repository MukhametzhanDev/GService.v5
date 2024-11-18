import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/pages/ad/my/myAdItem.dart';

class MyAdListPage extends StatefulWidget {
  const MyAdListPage({super.key});

  @override
  State<MyAdListPage> createState() => _MyAdListPageState();
}

class _MyAdListPageState extends State<MyAdListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackIconButton(), title: Text("Мои объявление")),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return MyAdItem(
              data: {},
              onPressed: (id) {},
              showOptions: (data) {},
              showListPromotionPage: (data) {});
        },
      ),
    );
  }
}
