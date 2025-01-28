import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/badge/badgeWidget.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gservice5/localization/extensions/context_extension.dart';
import 'package:gservice5/pages/leads/emptyLeadsPage.dart';
import 'package:gservice5/pages/leads/leadItem.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LeadListPage extends StatefulWidget {
  const LeadListPage({super.key});

  @override
  State<LeadListPage> createState() => _LeadListPageState();
}

class _LeadListPageState extends State<LeadListPage> {
  List data = [];
  bool loader = true;
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  String title = "";
  Map<String, dynamic> param = {};
  RefreshController refreshController = RefreshController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void showLoader() {
    if (!loader) {
      loader = true;
      setState(() {});
    }
  }

  Future getData() async {
    try {
      page = 1;
      Response response = await dio.get("/company-callbacks", data: param);
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    } finally {
      refreshController.refreshCompleted();
    }
  }

  void loadMoreAd() async {
    if (scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Response response = await dio.get("/company-callbacks",
            data: {"page": page.toString(), ...param});
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Лиды"),
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
      ),
      body: loader
          ? const LoaderComponent()
          : SmartRefresher(
              onRefresh: () async => await getData(),
              enablePullDown: true,
              enablePullUp: false,
              controller: refreshController,
              header: MaterialClassicHeader(
                  color: ColorComponent.mainColor,
                  backgroundColor: Colors.white),
              child: data.isEmpty
                  ? const EmptyLeadsListPage()
                  : ListView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      controller: scrollController,
                      itemBuilder: (context, int index) {
                        Map value = data[index];
                        if (data.length - 1 == index) {
                          return Column(children: [
                            LeadItem(data: value),
                            hasNextPage
                                ? const PaginationLoaderComponent()
                                : Container()
                          ]);
                        } else {
                          return LeadItem(data: value);
                        }
                      })),
    );
  }
}
