import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/ad/sectionCreateAdPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyAdEmptyPage extends StatelessWidget {
  const MyAdEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icons/clipboardOutline.svg", width: 80),
          Divider(indent: 12),
          Text("У вас пока нет опубликованных объявлении",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Divider(indent: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(
                        color: Colors.black, fontSize: 14, height: 1.5),
                    children: [
                      TextSpan(
                          text:
                              "Чтобы создать объявление, воспользуйтесь кнопкой «"),
                      TextSpan(
                          text: "Создать объявление",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(
                          text:
                              "» внизу страницы. После этого вы сможете разместить ваше объявление."),
                    ])),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SectionCreateAdPage()));
        },
        title: "Создать объявление",
        padding: EdgeInsets.symmetric(horizontal: 15),
      )),
    );
  }
}