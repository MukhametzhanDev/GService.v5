import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/createMainPage.dart';
import 'package:gservice5/pages/create/createSectionPage.dart';
import 'package:gservice5/pages/favorite/favoriteMainPage.dart';
import 'package:gservice5/pages/main/mainPage.dart';
import 'package:gservice5/pages/message/messageMainPage.dart';
import 'package:gservice5/pages/profile/verifyProfilePage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class IndividualBottomTab extends StatefulWidget {
  const IndividualBottomTab({super.key});

  @override
  State<IndividualBottomTab> createState() => _IndividualBottomTabState();
}

class _IndividualBottomTabState extends State<IndividualBottomTab>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  static final List<Map> _tabs = <Map>[
    {"icon": "assets/icons/home.svg", "label": "Главная"},
    {"icon": "assets/icons/heartOutline.svg", "label": "Избранное"},
    {"icon": "assets/icons/plus.svg", "label": "Объявление"},
    {"icon": "assets/icons/messages.svg", "label": "Сообщения"},
    {"icon": "assets/icons/user.svg", "label": "Профиль"},
  ];
  ScrollController scrollController = ScrollController();

  void _onItemTapped(int index) {
    if (_selectedIndex == 0 && index == 0) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else if (_selectedIndex == 2 && index == 2) {
      showMaterialModalBottomSheet(
          context: context, builder: (context) => CreateSectionPage());
    }
    setState(() {
      _selectedIndex = index;
    });
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
        MainPage(scrollController: scrollController),
        FavoriteMainPage(),
        CreateMainPage(),
        MessageMainPage(),
        VerifyProfilePage(),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                              padding: EdgeInsets.all(2),
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
          selectedLabelStyle: TextStyle(fontSize: 0),
          unselectedLabelStyle: TextStyle(fontSize: 0),
          onTap: _onItemTapped),
    );
  }
}