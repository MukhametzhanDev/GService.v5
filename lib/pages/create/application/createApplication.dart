import 'package:flutter/material.dart';
import 'package:gservice5/component/line/stepIndicator.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/pages/create/application/addressCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/descriptionCreateApplicationPage.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/pages/create/application/priceCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/typeEquipmentCreateApplicationPage.dart';

class CreateApplication extends StatefulWidget {
  const CreateApplication({super.key});

  @override
  State<CreateApplication> createState() => _CreateApplicationState();
}

class _CreateApplicationState extends State<CreateApplication> {
  int currentIndex = 0;
  List data = [
    {"title": "Описание заявки"},
    {"title": "Тип спецтехники"},
    {"title": "Цена"},
    {"title": "Указать адрес"},
  ];

  void nextPage() {
    closeKeyboard();
    currentIndex += 1;
    setState(() {});
  }

  void previousPage() {
    closeKeyboard();
    if (currentIndex == 0) {
      Navigator.pop(context);
    } else {
      currentIndex -= 1;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
          appBar: AppBar(
              leadingWidth: 200,
              leading: BackTitleButton(
                  onPressed: previousPage, title: data[currentIndex]['title']),
              actions: [
                CloseIconButton(iconColor: null, padding: true),
                SizedBox(width: 4)
              ],
              bottom: PreferredSize(
                  preferredSize: Size(double.infinity, 5),
                  child:
                      StepIndicator(lengthLine: 5, activeIndex: currentIndex))),
          body: IndexedStack(children: [
            // SectionCreateApplicationPage(nextPage: nextPage),
            DescriptionCreateApplicationPage(nextPage: nextPage),
            TypeEquipmentCreateApplicationPage(nextPage: nextPage),
            PriceCreateApplicationPage(nextPage: nextPage),
            AddressCreateApplicationPage(nextPage: nextPage),
          ], index: currentIndex)),
    );
  }
}
