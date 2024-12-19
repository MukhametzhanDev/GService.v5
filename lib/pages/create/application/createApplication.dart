import 'package:flutter/material.dart';
import 'package:gservice5/component/line/stepIndicator.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/pages/create/application/addressCreateApplicationPage.dart';
import 'package:gservice5/pages/create/options/getBrandEquipmentPage.dart';
import 'package:gservice5/pages/create/application/descriptionCreateApplicationPage.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/pages/create/application/getImageCreateApplicaitonPage.dart';
import 'package:gservice5/pages/create/options/getModelEquipmentPage.dart';
import 'package:gservice5/pages/create/application/priceCreateApplicationPage.dart';
import 'package:gservice5/pages/create/options/getProfessionPage.dart';
import 'package:gservice5/pages/create/options/getTypeEquipmentPage.dart';
import 'package:gservice5/pages/create/application/contactCreateApplicationPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class CreateApplication extends StatefulWidget {
  const CreateApplication({super.key});

  @override
  State<CreateApplication> createState() => _CreateApplicationState();
}

class _CreateApplicationState extends State<CreateApplication> {
  int currentIndex = 0;
  List<String> titles = [];
  List<Widget> pages = [];
  bool loader = true;

  @override
  void initState() {
    verifyData();
    super.initState();
  }

  @override
  void dispose() {
    clearData();
    super.dispose();
  }

  void clearData() {
    CreateData.data.clear();
    CreateData.images.clear();
  }

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

  Future verifyData() async {
    // bool hasToken = await ChangedToken().getToken() != "";
    Map options = CreateData.data['category']['options'];
    bool canLease = CreateData.data['category']['can_lease'];
    print(options);
    pages = [];
    if (options['has_transport_type']) {
      pages.add(GetTypeEquipmentPage(nextPage: nextPage));
      titles.add("Какой тип техники вы хотите купить?");
    }
    pages.add(DescriptionCreateApplicationPage(nextPage: nextPage));
    titles.add("Напишите подробности");
    if (options['has_transport_brand']) {
      pages.add(GetBrandEquipmentPage(nextPage: nextPage));
      titles.add("Марка техники");
    }
    if (options['has_transport_model']) {
      pages.add(GetModelEquipmentPage(nextPage: nextPage));
      titles.add("Модель техники");
    }
    if (options['has_profession']) {
      pages.add(GetProfessionPage(nextPage: nextPage));
      titles.add("Профессия");
    }
    pages.addAll([
      PriceCreateApplicationPage(nextPage: nextPage, canLease: canLease),
      AddressCreateApplicationPage(nextPage: nextPage)
    ]);
    titles.addAll(["Данные и цена", "Указать адрес"]);
    // if (!hasToken) {
    pages.addAll([
      ContactCreateApplicationPage(nextPage: nextPage),
      const GetImageCreateApplicaitonPage()
    ]);
    titles.addAll(["Контакты", "Дополнительно"]);
    // } else {
    //   titles.add("Дополнительно");
    //   pages.add(GetImageCreateApplicaitonPage());
    // }
    loader = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            loader
                ? Container()
                : Row(
                    children: [
                      Expanded(
                          child: BackTitleButton(
                              onPressed: previousPage,
                              title: titles[currentIndex])),
                      const CloseIconButton(iconColor: null, padding: true),
                    ],
                  ),
            Expanded(
              child: loader
                  ? const LoaderComponent()
                  : IndexedStack(index: currentIndex, children: pages),
            ),
          ],
        ),
      )),
    );
  }
}
