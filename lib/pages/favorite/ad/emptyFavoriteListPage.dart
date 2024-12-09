import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/login/loginPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EmptyFavoriteListPage extends StatefulWidget {
  const EmptyFavoriteListPage({super.key});

  @override
  State<EmptyFavoriteListPage> createState() => _EmptyFavoriteListPageState();
}

class _EmptyFavoriteListPageState extends State<EmptyFavoriteListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/icons/heartOutline.svg",
            width: 120, color: ColorComponent.gray['500']),
        Divider(indent: 12),
        Text("Место для избранного",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Divider(indent: 12),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Нажимайте на ♡ рядом с объявлениями или заявками, чтобы не потерять их",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 15, height: 1.5),
            )),
      ],
    ));
  }
}
