import 'package:flutter/material.dart';
import 'package:gservice5/component/bar/bottomBar/bottomNavigationWidget.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ContactBottomBarWidget extends StatelessWidget {
  const ContactBottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarWidget(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
              child: Button(
                  onPressed: () {},
                  widthIcon: 20,
                  icon: "chat.svg",
                  title: "Написать")),
          Divider(indent: 16),
          Expanded(
              child: Button(
            onPressed: () {},
            icon: "phone.svg",
            title: "Позвонить",
            widthIcon: 20,
            backgroundColor: ColorComponent.mainColor.withOpacity(.1),
          ))
        ],
      ),
    ));
  }
}
