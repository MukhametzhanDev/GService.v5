import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/leadingLogo.dart';
import 'package:gservice5/component/categories/request/getCategories.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/ad/list/adListPage.dart';
import 'package:gservice5/pages/auth/accountType/changed/changedAccountTypePage.dart';
import 'package:gservice5/pages/auth/accountType/changed/changedAccountWidget.dart';
import 'package:gservice5/pages/main/drawer/drawerOptions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List categories = [];
  List options = DrawerOptions.options;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    categories = await GetCategories().getData(context);
    setState(() {});
  }

  void showPage(Map value) {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AdListPage(category: value)));
  }

  void showChangeTypeModal() {
    Navigator.pop(context);
    showCupertinoModalBottomSheet(
        context: context, builder: (context) => ChangedAccountType());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 75,
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 160,
            leading: LeadingLogo(),
            actions: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorComponent.mainColor.withOpacity(.1)),
                  child: SvgPicture.asset('assets/icons/close.svg',
                      color: Colors.black),
                ),
              ),
              Divider(indent: 15)
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categories.map((value) {
                      return GestureDetector(
                          onTap: () => showPage(value),
                          child: SizedBox(
                              height: 48,
                              child: Row(children: [
                                SvgPicture.network(value['icon'], width: 24),
                                Divider(indent: 8),
                                Text(
                                  value['title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ])));
                    }).toList()),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: options.map((value) {
                      return SizedBox(
                        height: 48,
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/icons/${value['icon']}",
                                width: 24),
                            Divider(indent: 8),
                            Text(value['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 15)),
                          ],
                        ),
                      );
                    }).toList())
              ],
            ),
          ),
          bottomNavigationBar:
              BottomNavigationBarComponent(child: ChangedAccountWidget()),
        ));
  }
}
