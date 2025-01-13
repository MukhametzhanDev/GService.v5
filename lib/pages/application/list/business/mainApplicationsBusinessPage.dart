import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/switchRole/switchRoleWidget.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/badge/badgeWidget.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gservice5/pages/application/list/customer/applicationListWidget.dart';

class MainApplicationsBusinessPage extends StatefulWidget {
  final ScrollController scrollController;
  const MainApplicationsBusinessPage(
      {super.key, required this.scrollController});

  @override
  State<MainApplicationsBusinessPage> createState() =>
      _MainApplicationsBusinessPageState();
}

class _MainApplicationsBusinessPageState
    extends State<MainApplicationsBusinessPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              centerTitle: false,
              title: const Text("GService Business"),
              actions: [
                BadgeWidget(
                    position: badges.BadgePosition.topEnd(top: -4, end: -8),
                    showBadge: true,
                    body: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/icons/message.svg",
                            color: Colors.black))),
                const Divider(indent: 15)
              ],
              bottom: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 44),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2, color: ColorComponent.gray['100']!))),
                    child: TabBar(
                        indicatorWeight: 2,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.black,
                        unselectedLabelColor: ColorComponent.gray['500'],
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Для вас"),
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ColorComponent.mainColor
                                          .withOpacity(.1)),
                                  child: const Text(
                                    "99",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Все заказы"),
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ColorComponent.mainColor
                                          .withOpacity(.1)),
                                  child: const Text(
                                    "99",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          )
                        ]),
                  ))),
          body: TabBarView(children: [
            const Column(
              children: [SwitchRoleWidget()],
            ),
            ApplicationListWidget(
                param: {}, scrollController: ScrollController())
          ])),
    );
  }
}
