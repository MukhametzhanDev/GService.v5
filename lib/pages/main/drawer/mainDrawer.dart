import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/leadingLogo.dart';
import 'package:gservice5/component/categories/data/categoriesData.dart';
import 'package:gservice5/component/request/getCategories.dart';
import 'package:gservice5/component/switchRole/switchRoleWidget.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/ad/list/adListPage.dart';
import 'package:gservice5/pages/companies/companiesMainPage.dart';
import 'package:gservice5/pages/profile/news/allNewsPage.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List categories = CategoriesData.categories;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    if (categories.isEmpty) {
      categories = await GetCategories().getData(context);
    }
    setState(() {});
  }

  void showPage(Map value) {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AdListPage(category: value)));
  }

  void showChangeTypeModal() {
    Navigator.pop(context);
    // showCupertinoModalBottomSheet(
    //     context: context, builder: (context) => const ChangedAccountType());
  }

  void showDrawerPage(Map value) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => value['page']));
  }

  @override
  Widget build(BuildContext context) {
    List options = [
      {
        "full_title": context.localizations.companies,
        "title": context.localizations.companies,
        "icon": "usersGroup.svg",
        "page": const CompaniesMainPage()
      },
      {
        "full_title": context.localizations.news,
        "title": context.localizations.news,
        "icon": "bullhorn.svg",
        "page": const AllNewsPage(showBackButton: true)
      },
      {
        "full_title": context.localizations.guide,
        "title": context.localizations.guide,
        "icon": "userHeadset.svg",
        "page": "AllNewsPage"
      },
    ];
    return SizedBox(
        width: MediaQuery.of(context).size.width - 75,
        child: Scaffold(
            appBar: AppBar(
              leadingWidth: 180,
              leading: const LeadingLogo(),
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
                const Divider(indent: 15)
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: categories.map((value) {
                        return GestureDetector(
                            onTap: () => showPage(value),
                            child: Container(
                                color: Colors.white,
                                height: 48,
                                child: Row(children: [
                                  SvgPicture.network(value['icon'], width: 24),
                                  const Divider(indent: 8),
                                  Text(
                                    value['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ])));
                      }).toList()),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: options.map((value) {
                        return GestureDetector(
                          onTap: () => showDrawerPage(value),
                          child: Container(
                            color: Colors.white,
                            height: 48,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    "assets/icons/${value['icon']}",
                                    width: 24),
                                const Divider(indent: 8),
                                Text(value['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                ],
              ),
            ),
            bottomNavigationBar: const BottomNavigationBarComponent(
                child: SwitchRoleWidget()
                // SizedBox(
                //     height: 42,
                //     child: Row(
                //       children: [
                //         Expanded(
                //           child: Button(
                //               onPressed: () {},
                //               padding:
                //                   const EdgeInsets.symmetric(horizontal: 10),
                //               title: "Стать партнером"),
                //         ),
                //         SvgPicture.asset("assets/icons/questionOutline.svg"),
                //         const Divider(indent: 20)
                //       ],
                //     )),
                )));
  }
}
