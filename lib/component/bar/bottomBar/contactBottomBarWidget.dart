import 'package:flutter/material.dart';
import 'package:gservice5/component/bar/bottomBar/bottomNavigationWidget.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/counter/counterClickStatistic.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ContactBottomBarWidget extends StatefulWidget {
  final bool hasAd;
  final int id;
  final List phones;
  const ContactBottomBarWidget(
      {super.key, required this.hasAd, required this.id, required this.phones});

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
            onPressed: () {
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => ContastListModal(phones: widget.phones),
              );
            },
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

class ContastListModal extends StatefulWidget {
  final List phones;
  const ContastListModal({super.key, required this.phones});

  @override
  State<ContastListModal> createState() => _ContastListModalState();
}

class _ContastListModalState extends State<ContastListModal> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      AppBar(
          centerTitle: false,
          title: Text("Конакты"),
          actions: [CloseIconButton(iconColor: null, padding: true)]),
      Column(
          children: widget.phones.map((value) {
        return ListTile(
          title: Text("+${value}"),
        );
      }).toList()),
      Divider(height: MediaQuery.of(context).padding.bottom + 15)
    ]);
  }
}
