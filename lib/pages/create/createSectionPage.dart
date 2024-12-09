import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/functions/token/changedToken.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/auth/emptyTokenPage.dart';
import 'package:gservice5/pages/create/ad/sectionCreateAdPage.dart';
import 'package:gservice5/pages/create/application/sectionCreateApplicationPage.dart';

class CreateSectionPage extends StatefulWidget {
  const CreateSectionPage({super.key});

  @override
  State<CreateSectionPage> createState() => _CreateSectionPageState();
}

class _CreateSectionPageState extends State<CreateSectionPage> {
  bool verifyToken = false;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  Future getToken() async {
    verifyToken = await ChangedToken().getToken() != null;
    setState(() {});
  }

  List data = [
    {
      "title": "Объявление",
      "subTitle": "Для продажи и аренды спецтехники и запчастей",
      "page": SectionCreateAdPage(),
    },
    {
      "title": "Заявки",
      "subTitle": "Сообщите о требуемой услуге, спецтехнике или запчасти",
      "page": SectionCreateApplicationPage(),
    },
    {
      "title": "Найти работу",
      "subTitle":
          "Выложите свое резюме о вашей специальности в сфере спецтехники"
    },
    // {
    //   "title": "Логистика",
    //   "subTitle": "Если вы оказываете транспортировку. грузоперевозку"
    // },
  ];
  int currentIndex = 0;

  void activedItem(int index) {
    currentIndex = index;
    setState(() {});
  }

  void showPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => data[currentIndex]['page']));
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text("Новое объявление"),
          actions: [CloseIconButton(iconColor: null, padding: true)],
        ),
        body: !verifyToken
            ? EmptyTokenPage()
            : SingleChildScrollView(
                physics: physics,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                    children: data.map((value) {
                  int index = data.indexOf(value);
                  bool active = index == currentIndex;
                  return GestureDetector(
                    onTap: () {
                      activedItem(index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 1,
                              color: active
                                  ? ColorComponent.mainColor
                                  : Color(0xffeeeeee))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: active ? 4 : 1,
                                      color: active
                                          ? Color(0xff1A56DB)
                                          : Color(0xffD1D5DB)))),
                          Divider(indent: 12),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(value['title'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  Divider(height: 4),
                                  Text(value['subTitle'],
                                      style: TextStyle(
                                          color: ColorComponent.gray['500']))
                                ]),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList()),
              ),
        bottomNavigationBar: !verifyToken
            ? null
            : BottomNavigationBarComponent(
                child: Button(
                    onPressed: showPage,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    title: "Продолжить")),
      );
    });
  }
}
 