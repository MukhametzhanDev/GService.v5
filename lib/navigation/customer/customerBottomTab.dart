import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/badge/badgeWidget.dart';
import 'package:gservice5/pages/create/ad/sectionCreateAdPage.dart';
import 'package:gservice5/pages/favorite/favoriteMainPage.dart';
import 'package:gservice5/pages/main/mainPage.dart';
import 'package:gservice5/pages/message/messageMainPage.dart';
import 'package:gservice5/pages/profile/verifyProfilePage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CustomerBottomTab extends StatefulWidget {
  const CustomerBottomTab({super.key});

  @override
  State<CustomerBottomTab> createState() => _CustomerBottomTabState();
}

class _CustomerBottomTabState extends State<CustomerBottomTab>
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

  final analytics = GetIt.I<FirebaseAnalytics>();

  void _onItemTapped(int index) {
    if (_selectedIndex == 0 && index == 0) {
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

      analytics.logEvent(name: GAEventName.screenView, parameters: {
        GAKey.screenName: GAParams.mainPage,
      }).catchError((e) {
        debugPrint(e);
      });
    } else if (index == 2) {
      showMaterialModalBottomSheet(
          context: context,
          enableDrag: false,
          builder: (context) => const SectionCreateAdPage()).then((value) {
        if (value == "ad") {
          Navigator.pushNamed(context, "MyAdListPage");
        } else if (value == "application") {
          Navigator.pushNamed(context, "MyApplicationListPage");
        }
      });

      analytics.logEvent(name: GAEventName.screenView, parameters: {
        GAKey.screenName: GAParams.tabBottomAd,
      }).catchError((e) {
        debugPrint(e);
      });
    } else {
      _selectedIndex = index;

      analytics.logEvent(name: GAEventName.screenView, parameters: {
        GAKey.screenName: index == 1
            ? GAParams.favoriteMainPage
            : index == 3
                ? GAParams.messageMainPage
                : index == 4
                    ? GAParams.verifyProfilePage
                    : GAParams.mainPage,
      }).catchError((e) {
        debugPrint(e);
      });

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
        MainPage(
          scrollController: scrollController,
          // key: GlobalKey(debugLabel: "main_page"),
        ),
        const FavoriteMainPage(),
        Container(),
        const MessageMainPage(),
        const VerifyProfilePage(),
      ]),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorTheme['white_black'],
          elevation: 0,
          items: _tabs.map((value) {
            int index = _tabs.indexOf(value);
            return BottomNavigationBarItem(
                icon: BadgeWidget(
                    position: badges.BadgePosition.topEnd(top: -8, end: -6),
                    showBadge: index == 3,
                    body: Wrap(
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
