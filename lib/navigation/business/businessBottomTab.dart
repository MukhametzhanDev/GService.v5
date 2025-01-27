import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/gen/assets.gen.dart';
import 'package:gservice5/pages/ad/my/business/businessMainPage.dart';
import 'package:gservice5/pages/application/list/business/mainApplicationsBusinessPage.dart';
import 'package:gservice5/pages/contractor/marketing/marketingPage.dart';
import 'package:gservice5/pages/create/ad/sectionCreateAdPage.dart';
import 'package:gservice5/pages/leads/leadListPage.dart';
import 'package:gservice5/pages/profile/business/businessProfilePage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

@RoutePage()
class BusinessBottomTab extends StatefulWidget {
  const BusinessBottomTab({super.key});

  @override
  State<BusinessBottomTab> createState() => _BusinessBottomTabState();
}

class _BusinessBottomTabState extends State<BusinessBottomTab> {
  int _selectedIndex = 0;
  ScrollController scrollController = ScrollController();

  //changed tab and scroll up
  void _onItemTapped(int index) {
    if (_selectedIndex == 0 && index == 0) {
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else if (index == 2) {
      showMaterialModalBottomSheet(
          context: context,
          enableDrag: false,
          builder: (context) => const SectionCreateAdPage()).then((value) {
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
    final List<Map> tabs = <Map>[
      {"icon": Assets.icons.clipboardOutline, "label": "Мои"},
      {"icon": Assets.icons.file, "label": context.localizations.order},
      {"icon": Assets.icons.plus, "label": context.localizations.ad},
      {"icon": Assets.icons.phoneOutline, "label": "Лиды"},
      {"icon": Assets.icons.user, "label": "Профиль"}
    ];
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: [
        BusinessMainPage(scrollController: scrollController),
        MainApplicationsBusinessPage(scrollController: scrollController),
        Container(),
        // CreateMainPage(),
        const LeadListPage(),
        const BusinessProfilePage(),
      ]),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorTheme['white_black'],
          elevation: 0,
          items: tabs.map((value) {
            int index = tabs.indexOf(value);
            return BottomNavigationBarItem(
                icon: Wrap(
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
                    ]),
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
