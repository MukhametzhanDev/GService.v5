import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/badge/badgeWidget.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gservice5/pages/application/list/business/activityApplicationListPage.dart';
import 'package:gservice5/pages/application/list/customer/applicationListWidget.dart';
import 'package:gservice5/pages/create/application/sectionCreateApplicationPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
  Map data = {};
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/activity-applications-count");
      if (response.data['success']) {
        data = response.data['data'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void showCreateApplicationPage() {
    showMaterialModalBottomSheet(
        context: context, builder: (context) => const SectionCreateApplicationPage());
  }

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
                              loader
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: ColorComponent.gray['200']))
                                  : data['activity_applications'] == 0
                                      ? Container()
                                      : Container(
                                          height: 20,
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: ColorComponent.mainColor
                                                  .withOpacity(.6)),
                                          child: Text(
                                            data['activity_applications']
                                                .toString(),
                                            style: const TextStyle(
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
                              loader
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: ColorComponent.gray['200']))
                                  : data['applications'] == 0
                                      ? Container()
                                      : Container(
                                          height: 20,
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: ColorComponent.mainColor
                                                  .withOpacity(.6)),
                                          child: Text(
                                            data['applications'].toString(),
                                            style: const TextStyle(
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
          const ActivityApplicationListPage(),
          ApplicationListWidget(
              param: const {}, scrollController: ScrollController())
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: showCreateApplicationPage,
          elevation: 0,
          backgroundColor: ColorComponent.mainColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: SvgPicture.asset("assets/icons/plusOutline.svg",
              color: Colors.black),
        ),
      ),
    );
  }
}
