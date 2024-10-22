import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class RubricMainButtons extends StatelessWidget {
  RubricMainButtons({super.key});
  List<Map> rubrics = [
    {"title": "Продажа", "icon": "basket.svg"},
    {"title": "Аренда", "icon": "rent.svg"},
    {"title": "Запчасти", "icon": "sparePart.svg"},
    {"title": "Заявки", "icon": "file.svg"},
    {"title": "Механик", "icon": "userSettings.svg"},
    {"title": "Водитель", "icon": "driver.svg"},
    {"title": "Компании", "icon": "usersGroup.svg"},
    {"title": "Новости", "icon": "globe.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
            spacing: 7,
            runSpacing: 7,
            children: rubrics.map((value) {
              return Container(
                width: MediaQuery.of(context).size.width / 4 - 13,
                height: MediaQuery.of(context).size.width / 4 - 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorComponent.mainColor.withOpacity(.1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/${value['icon']}'),
                    Divider(height: 8),
                    Text(value['title'],
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500))
                  ],
                ),
              );
            }).toList())
      ],
    );
  }
}
