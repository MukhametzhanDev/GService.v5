import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:badges/badges.dart' as badges;
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
    {"icon": "assets/icons/home.svg", "label": "Home"},
    {"icon": "assets/icons/heartOutline.svg", "label": "Home"},
    {"icon": "assets/icons/plus.svg", "label": "Объявление"},
    {"icon": "assets/icons/message.svg", "label": "Home"},
    {"icon": "assets/icons/profile.svg", "label": "Home"},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorTheme = ThemeColorComponent.ColorsTheme(context);
    return Scaffold(
      body: IndexedStack(children: [
        const MainPage(),
        const FavoriteMainPage(),
        const CreateAdMainPage(),
        const MessageMainPage(),
        const VerifyProfilePage(),
      ], index: _selectedIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorTheme['white_black'],
          items: _tabs.map((value) {
            int index = _tabs.indexOf(value);
            return BottomNavigationBarItem(
                icon: badges.Badge(
                    badgeAnimation: const badges.BadgeAnimation.fade(),
                    position: badges.BadgePosition.topEnd(top: -12, end: -18),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Colors.transparent,
                      padding: EdgeInsets.all(6),
                    ),
                    showBadge: index == 3,
                    badgeContent: Container(
                      height: 16,
                      width: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red[500],
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
                          SvgPicture.asset(
                            value['icon'],
                            color: index == 2
                                ? null
                                : index == _selectedIndex
                                    ? ColorComponent.mainColor
                                    : Colors.grey[500],
                          ),
                          index == 2
                              ? Container()
                              : Text(value['label'],
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: index == _selectedIndex
                                          ? ColorComponent.mainColor
                                          : Colors.grey[500]))
                        ])),
                label: "");
          }).toList(),
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: ColorComponent.mainColor,
          unselectedItemColor: Colors.grey[500],
          selectedLabelStyle: TextStyle(fontSize: 0),
          unselectedLabelStyle: TextStyle(fontSize: 0),
          onTap: _onItemTapped),
    );
  }
}
