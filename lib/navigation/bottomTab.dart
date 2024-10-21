import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gservice5/component/badge/badgeBottomTab.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/createAdMainPage.dart';
import 'package:gservice5/pages/favorite/favoriteMainPage.dart';
import 'package:gservice5/pages/main/mainPage.dart';
import 'package:gservice5/pages/message/messageMainPage.dart';
import 'package:gservice5/pages/profile/verifyProfilePage.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({super.key});

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _selectedIndex = 0;
  static final List<Map> _tabs = <Map>[
    {"icon": "assets/icons/home.svg", "label": "Главная"},
    {"icon": "assets/icons/heart.svg", "label": "Избранное"},
    {"icon": "assets/icons/plus.svg", "label": "Объявление"},
    {"icon": "assets/icons/messages.svg", "label": "Сообщения"},
    {"icon": "assets/icons/user.svg", "label": "Профиль"},
  ];

  //changed tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorTheme = ThemeColorComponent.ColorsTheme(context);
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: const [
        MainPage(),
        FavoriteMainPage(),
        CreateAdMainPage(),
        MessageMainPage(),
        VerifyProfilePage(),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorTheme['white_black'],
          items: _tabs.map((value) {
            int index = _tabs.indexOf(value);
            return BottomNavigationBarItem(
                icon: BadgeBottomTab(
                    tab: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.vertical,
                        children: [
                          SvgPicture.asset(
                            value['icon'],
                            color: index == 2
                                ? null
                                : index == _selectedIndex
                                    ? ColorComponent.mainColor
                                    : Colors.grey[500],
                          ),
                          Text(value['label'],
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: index == _selectedIndex
                                      ? ColorComponent.mainColor
                                      : ColorComponent.gray['500']))
                        ]),
                    showBadge: index == 3),
                label: "");
          }).toList(),
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: ColorComponent.gray['500'],
          unselectedItemColor: ColorComponent.gray['500'],
          selectedLabelStyle: TextStyle(fontSize: 0),
          unselectedLabelStyle: TextStyle(fontSize: 0),
          onTap: _onItemTapped),
    );
  }
}
