import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/createSectionPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CreateMainPage extends StatefulWidget {
  const CreateMainPage({super.key});

  @override
  State<CreateMainPage> createState() => _CreateMainPageState();
}

class _CreateMainPageState extends State<CreateMainPage> {
  void createSectionPage() {
    showMaterialModalBottomSheet(
        context: context, builder: (context) => CreateSectionPage());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 50),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorComponent.gray['100']),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [Tab(text: "Мои объявление"), Tab(text: "Мои заявки")],
                  labelColor: Colors.black,
                  indicator: BoxDecoration(
                    color: ColorComponent.mainColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      bottom: BorderSide(
                          color: ColorComponent.mainColor, width: 6.0),
                    ),
                  ),
                ),
              )),
        ),
        body: TabBarView(children: [Container(),Container()]),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: createSectionPage,
                padding: EdgeInsets.symmetric(horizontal: 15),
                title: "Создать")),
      ),
    );
  }
}
