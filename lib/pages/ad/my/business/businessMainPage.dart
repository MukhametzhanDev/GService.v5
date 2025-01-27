import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/switchRole/changeRoleBusinessModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/badge/badgeWidget.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gservice5/pages/ad/my/business/fixedAdBusinessFilterAppBar.dart';
import 'package:gservice5/pages/ad/my/business/updateAds.dart';
import 'package:gservice5/pages/ad/my/myAdListWidgetTest.dart';
import 'package:gservice5/pages/ad/my/statusAd/statusAdsWidget.dart';
import 'package:gservice5/provider/myAdFilterProvider.dart';
import 'package:gservice5/provider/nameCompanyProvider.dart';
import 'package:gservice5/provider/statusMyAdCountProvider.dart';
import 'package:provider/provider.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class BusinessMainPage extends StatefulWidget {
  final ScrollController scrollController;
  const BusinessMainPage({super.key, required this.scrollController});

  @override
  State<BusinessMainPage> createState() => _BusinessMainPageState();
}

class _BusinessMainPageState extends State<BusinessMainPage>
    with SingleTickerProviderStateMixin {
  List categories = [];
  int currentCategory = 0;
  bool loader = true;
  late TabController tabController;
  late UpdateAds updateAds;

  @override
  void initState() {
    getCategories();
    addFilterValue();
    super.initState();
  }

  Future getCategories() async {
    try {
      Response response = await dio.get("/my-ads-category-count");
      if (response.data['success']) {
        categories = verifyTabs(response.data['data']);
        tabController = TabController(length: categories.length, vsync: this);
        tabController.addListener(() => updateFilterValue());
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void addFilterValue() {
    UpdateAds.valueStream.listen((value) {
      categories[currentCategory]['filter'] = value;
    });
  }

  void updateFilterValue() {
    if (categories.isNotEmpty) {
      if (!tabController.indexIsChanging) {
        currentCategory = tabController.index;
        Provider.of<MyAdFilterProvider>(context, listen: false).changedIndex =
            currentCategory;
        Provider.of<StatusMyAdCountProvider>(context, listen: false)
            .getData(categories[currentCategory]['id']);
      }
    }

    // Map value = categories[currentCategory];
    // Map<String, dynamic> param = {"status": "pending", "package": false};
    // if (value.containsKey("filter")) {
    //   param = categories[currentCategory]['filter'];
    // }
    // UpdateAds.addValue = param;
  }

  List verifyTabs(List values) {
    List data = values.where((value) => value['count'] != 0).toList();
    Provider.of<MyAdFilterProvider>(context, listen: false)
        .addDefaultDataFilter(data);
    return data;
  }

  void showSwitchAccountModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) => const ChangeRoleBusinessModal());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NameCompanyProvider>(builder: (context, data, child) {
      return DefaultTabController(
          length: categories.length,
          child: loader
              ? const Scaffold(body: LoaderComponent())
              : Scaffold(
                  appBar: AppBar(
                      centerTitle: false,
                      title: GestureDetector(
                        onTap: showSwitchAccountModal,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(data.nameValue),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: data.dealerValue
                                      ? SvgPicture.asset(
                                          'assets/icons/badgeСheck.svg')
                                      : Container()),
                              SvgPicture.asset('assets/icons/down.svg',
                                  width: 20, color: Colors.black)
                            ]),
                      ),
                      actions: [
                        BadgeWidget(
                            position:
                                badges.BadgePosition.topEnd(top: -4, end: -8),
                            showBadge: true,
                            body: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                    "assets/icons/message.svg",
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
                                controller: tabController,
                                indicatorWeight: 2,
                                indicatorSize: TabBarIndicatorSize.label,
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                labelColor: Colors.black,
                                unselectedLabelStyle: const TextStyle(
                                    fontWeight: FontWeight.w400),
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w500),
                                unselectedLabelColor:
                                    ColorComponent.gray['500'],
                                tabs: categories.map((value) {
                                  return Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(value['title']),
                                        Container(
                                          width: 20,
                                          height: 20,
                                          margin:
                                              const EdgeInsets.only(left: 10),
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
                      controller: tabController,
                      children: categories.map((value) {
                        return Column(
                          children: [
                            const Divider(height: 10),
                            StatusAdsWidget(data: value),
                            const FixedAdBusinessFilterAppBar(),
                            const Expanded(child: MyAdListWidgetTest()),
                          ],
                        );
                      }).toList()),
                ));
    });
  }
}
