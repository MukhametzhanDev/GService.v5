import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class NotFoundPage extends StatefulWidget {
  final Widget child;
  final int? statusCode;
  const NotFoundPage(
      {super.key, required this.child, required this.statusCode});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return widget.statusCode == 404
        ? Scaffold(
            appBar: AppBar(
                leading: BackTitleButton(title: "Назад"), leadingWidth: 100),
            body: Container(
              width: MediaQuery.of(context).size.width - 50,
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/404.png"),
                  Divider(indent: 15),
                  Text(
                    "Страница не найдено",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBarComponent(
                child: Button(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    title: "Перейти на главную")),
          )
        : widget.child;
  }
}
