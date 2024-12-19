import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class EmptyNewsPage extends StatefulWidget {
  const EmptyNewsPage({super.key});

  @override
  State<EmptyNewsPage> createState() => _EmptyNewsPageState();
}

class _EmptyNewsPageState extends State<EmptyNewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/icons/bullhorn.svg",
            width: 120, color: ColorComponent.gray['500']),
        const Divider(indent: 12),
        const Text("Новости пока отсутствуют",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const Divider(indent: 12),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "На данный момент новостей нет, но скоро здесь появятся самые свежие и актуальные события.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 15, height: 1.5),
            )),
      ],
    ));
  }
}
