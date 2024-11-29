import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/favoriteButton.dart';
import 'package:gservice5/component/modal/contact/shortContactModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/application/viewApplicationPage.dart';

class ApplicationItem extends StatelessWidget {
  final int index;
  const ApplicationItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewApplicationPage(id: 0)));
      },
      onLongPress: () {
        onLongPressShowNumber({}, context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Divider(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                height: 24,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: ColorComponent.mainColor),
                child: Text(
                    index % 2 == 0 ? "Аренда спецтехники" : "Покупка запчастей",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
            FavoriteButton()
          ]),
          Divider(height: 12),
          Text("Нужен экскаватор 2-ух кубовый",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: ColorComponent.blue['700'])),
          Divider(height: 8),
          Text("Договорная",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Divider(height: 12),
          Text(
            "Нужен экскаватор на 4-5дней район рв90. Если имеется самосвалы тоже пригодится . Балласт точка а и б 300метр",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Divider(height: 12),
          Row(children: [
            SvgPicture.asset("assets/icons/pin.svg",
                width: 16, color: ColorComponent.gray['500']),
            Divider(indent: 4),
            Text("г. Алматы",
                style: TextStyle(
                    fontSize: 12,
                    // fontWeight: FontWeight.3500,
                    color: ColorComponent.gray['500'])),
            Divider(indent: 12),
            Text("15 Сент 04:20",
                style:
                    TextStyle(fontSize: 12, color: ColorComponent.gray['500'])),
            Expanded(child: Container()),
            Row(children: [
              SvgPicture.asset("assets/icons/eye.svg"),
              Divider(indent: 4),
              Text("123",
                  style: TextStyle(
                      fontSize: 12, color: ColorComponent.gray['500']))
            ])
          ]),
          Divider(height: 16),
        ]),
      ),
    );
  }
}
