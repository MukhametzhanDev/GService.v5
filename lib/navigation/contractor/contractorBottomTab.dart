import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/my/myAdListPage.dart';
import 'package:gservice5/pages/contractor/dashboard/dashboardPage.dart';
import 'package:gservice5/pages/contractor/marketing/marketingPage.dart';
import 'package:gservice5/pages/create/createSectionPage.dart';
import 'package:gservice5/pages/message/messageMainPage.dart';
import 'package:gservice5/pages/profile/contractor/contractorProfilePage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:badges/badges.dart' as badges;

class ContractorBottomTab extends StatefulWidget {
  const ContractorBottomTab({super.key});

  @override
  State<ContractorBottomTab> createState() => _ContractorBottomTabState();
}

class _ContractorBottomTabState extends State<ContractorBottomTab> {
  int _selectedIndex = 0;
  static final List<Map> _tabs = <Map>[
    {"icon": "assets/icons/home.svg", "label": "Главная"},
    {"icon": "assets/icons/chartOutline.svg", "label": "Маркетинг"},
    {"icon": "assets/icons/plus.svg", "label": "Объявление"},
    {"icon": "assets/icons/messages.svg", "label": "Сообщения"},
    {"icon": "assets/icons/user.svg", "label": "Профиль"},
  ];
  ScrollController scrollController = ScrollController();

  //changed tab and scroll up
  void _onItemTapped(int index) {
    if (_selectedIndex == 0 && index == 0) {
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else if (index == 2) {
      showMaterialModalBottomSheet(
          context: context,
          builder: (context) => const CreateSectionPage()).then((value) {
        if (value == "ad") {
          Navigator.pushNamed(context, "MyAdListPage");
        }
      });
    } else {
      _selectedIndex = index;
      setState(() {});
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorTheme = ThemeColorComponent.ColorsTheme(context);
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: [
        DashboardPage(scrollController: scrollController),
        const MarketingPage(),
        Container(),
        // CreateMainPage(),
        const MessageMainPage(),
        const ContractorProfilePage(),
      ]),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorTheme['white_black'],
          elevation: 0,
          items: _tabs.map((value) {
            int index = _tabs.indexOf(value);
            return BottomNavigationBarItem(
                icon: badges.Badge(
                    badgeAnimation: const badges.BadgeAnimation.fade(),
                    position: badges.BadgePosition.topEnd(top: -8, end: -6),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Colors.transparent,
                      padding: EdgeInsets.all(6),
                    ),
                    showBadge: index == 3,
                    badgeContent: Container(
                      height: 18,
                      width: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: ColorComponent.red['500'],
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text("99",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ),
                    child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.vertical,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: index == _selectedIndex && index != 2
                                      ? ColorComponent.mainColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8)),
                              child: SvgPicture.asset(
                                value['icon'],
                                width: index == 2 ? 32 : null,
                                color: index == 2
                                    ? null
                                    : index == _selectedIndex
                                        ? Colors.black.withOpacity(.8)
                                        : ColorComponent.gray['500'],
                              )),
                          index == 2
                              ? Container()
                              : Text(value['label'],
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: index == _selectedIndex
                                          ? Colors.black
                                          : ColorComponent.gray['500']))
                        ])),
                label: "");
          }).toList(),
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontSize: 0),
          unselectedLabelStyle: const TextStyle(fontSize: 0),
          onTap: _onItemTapped),
    );
  }
}
