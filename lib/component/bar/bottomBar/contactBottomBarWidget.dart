import 'package:flutter/material.dart';
import 'package:gservice5/component/bar/bottomBar/bottomNavigationWidget.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/counter/counterClickStatistic.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class ContactBottomBarWidget extends StatefulWidget {
  final bool hasAd;
  final int id;
  const ContactBottomBarWidget(
      {super.key, required this.hasAd, required this.id});

  @override
  State<ContactBottomBarWidget> createState() => _ContactBottomBarWidgetState();
}

class _ContactBottomBarWidgetState extends State<ContactBottomBarWidget> {
  void writed() async {
    if (widget.hasAd) {
    } else {
      await getCountClickApplication(widget.id, "write");
    }
  }

  void called() async {
    if (widget.hasAd) {
    } else {
      await getCountClickApplication(widget.id, "call");
    }
  }

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
          const Divider(indent: 16),
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
