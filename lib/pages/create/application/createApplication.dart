import 'package:flutter/material.dart';
import 'package:gservice5/component/line/stepIndicator.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/pages/create/application/addressCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/descriptionCreateApplicationPage.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/pages/create/application/getImageCreateApplicaitonPage.dart';
import 'package:gservice5/pages/create/application/priceCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/typeEquipmentCreateApplicationPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/getImageWidget.dart';

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
    {"title": "Дополнительно"}
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

  List<Widget> verifyPage() {
    Map options = CreateData.data['category']['options'];
    List<Widget> pages = [];
    if (options['has_transport_type']) {
      pages.add(TypeEquipmentCreateApplicationPage(nextPage: nextPage));
    } else if (options['has_transport_brand']) {
      pages.add(TypeEquipmentCreateApplicationPage(nextPage: nextPage));
    } else if (options['has_transport_model']) {
      pages.add(TypeEquipmentCreateApplicationPage(nextPage: nextPage));
    } else if (options['has_profession']) {
      pages.add(TypeEquipmentCreateApplicationPage(nextPage: nextPage));
    }
    return pages;
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
          body: IndexedStack(index: currentIndex, children: [
            DescriptionCreateApplicationPage(nextPage: nextPage),
            ...verifyPage(),
            PriceCreateApplicationPage(nextPage: nextPage),
            AddressCreateApplicationPage(nextPage: nextPage),
            GetImageCreateApplicaitonPage()
          ])),
    );
  }
}
