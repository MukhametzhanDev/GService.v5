import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/badge/badgeWidget.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gservice5/pages/ad/my/business/fixedAdBusinessFilterAppBar.dart';
import 'package:gservice5/pages/ad/my/business/myAdListBusiness.dart';
import 'package:gservice5/pages/ad/my/myAdListPage.dart';
import 'package:gservice5/pages/ad/my/myAdListWidget.dart';

class BusinessMainPage extends StatefulWidget {
  final ScrollController scrollController;
  const BusinessMainPage({super.key, required this.scrollController});

  @override
  State<BusinessMainPage> createState() => _BusinessMainPageState();
}

class _BusinessMainPageState extends State<BusinessMainPage> {
  List categories = [];
  bool loader = true;

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  Future getCategories() async {
    try {
      Response response = await dio.get("/my-ads-category-count");
      if (response.data['success']) {
        categories = verifyTabs(response.data['data']);
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  List verifyTabs(List values) {
    List data = values.where((value) => value['count'] != 0).toList();
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: categories.length,
        child: loader
            ? const Scaffold(body: LoaderComponent())
            : Scaffold(
                appBar: AppBar(
                    centerTitle: false,
                    title: const Text("GService Business"),
                    actions: [
                      BadgeWidget(
                          position:
                              badges.BadgePosition.topEnd(top: -4, end: -8),
                          showBadge: true,
                          body: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset("assets/icons/message.svg",
                                  color: Colors.black))),
                      const Divider(indent: 15)
                    ],
                    bottom: PreferredSize(
                        preferredSize:
                            Size(MediaQuery.of(context).size.width, 44),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 2,
                                      color: ColorComponent.gray['100']!))),
                          child: TabBar(
                              indicatorWeight: 2,
                              indicatorSize: TabBarIndicatorSize.label,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              labelColor: Colors.black,
                              unselectedLabelStyle:
                                  const TextStyle(fontWeight: FontWeight.w400),
                              labelStyle:
                                  const TextStyle(fontWeight: FontWeight.w500),
                              unselectedLabelColor: ColorComponent.gray['500'],
                              tabs: categories.map((value) {
                                return Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(value['title']),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        margin: const EdgeInsets.only(left: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: ColorComponent.mainColor
                                                .withOpacity(.1)),
                                        child: Text(
                                          value['count'].toString(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }).toList()),
                        ))),
                body: TabBarView(
                    children: categories.map((value) {
                  return const Column(
                    children: [
                      FixedAdBusinessFilterAppBar(),
                      Expanded(child: MyAdListWidget()),
                    ],
                  );
                }).toList()),
              ));
  }
}