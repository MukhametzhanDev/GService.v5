import 'package:flutter/material.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/line/stepIndicator.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/pages/create/application/addressCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/brandEquipmentCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/descriptionCreateApplicationPage.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/pages/create/application/getImageCreateApplicaitonPage.dart';
import 'package:gservice5/pages/create/application/modelEquipmentCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/priceCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/professionCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/typeEquipmentCreateApplicationPage.dart';
import 'package:gservice5/pages/create/application/contactCreateApplicationPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class CreateApplication extends StatefulWidget {
  const CreateApplication({super.key});

  @override
  State<CreateApplication> createState() => _CreateApplicationState();
}

class _CreateApplicationState extends State<CreateApplication> {
  int currentIndex = 0;
  List<String> titles = ["Описание заявки"];
  List<Widget> pages = [];
  bool loader = true;

  @override
  void initState() {
    verifyData();
    super.initState();
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
    bool hasToken = await ChangedToken().getToken() != "";
    Map options = CreateData.data['category']['options'];
    print(options);
    pages = [DescriptionCreateApplicationPage(nextPage: nextPage)];
    if (options['has_transport_type']) {
      pages.add(TypeEquipmentCreateApplicationPage(nextPage: nextPage));
      titles.add("Тип техники");
    }
    if (options['has_transport_brand']) {
      pages.add(BrandEquipmentCreateApplicationPage(nextPage: nextPage));
      titles.add("Марка техники");
    }
    if (options['has_transport_model']) {
      pages.add(ModelEquipmentCreateApplicationPage(nextPage: nextPage));
      titles.add("Модель техники");
    }
    if (options['has_profession']) {
      pages.add(ProfessionCreateApplicationPage(nextPage: nextPage));
      titles.add("Профессия");
    }
    pages.addAll([
      PriceCreateApplicationPage(nextPage: nextPage),
      AddressCreateApplicationPage(nextPage: nextPage)
    ]);
    titles.addAll(["Цена", "Указать адрес"]);
    // if (!hasToken) {
    pages.addAll([
      ContactCreateApplicationPage(nextPage: nextPage),
      GetImageCreateApplicaitonPage()
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
          appBar: loader
              ? null
              : AppBar(
                  leadingWidth: MediaQuery.of(context).size.width - 100,
                  leading: BackTitleButton(
                      onPressed: previousPage, title: titles[currentIndex]),
                  actions: [
                    CloseIconButton(iconColor: null, padding: true),
                    SizedBox(width: 4)
                  ],
                  bottom: PreferredSize(
                      preferredSize: Size(double.infinity, 5),
                      child: StepIndicator(
                          lengthLine: pages.length,
                          activeIndex: currentIndex))),
          body: loader
              ? LoaderComponent()
              : IndexedStack(index: currentIndex, children: pages)),
    );
  }
}
