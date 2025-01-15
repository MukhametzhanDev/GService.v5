import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/list/adListLoader.dart';
import 'package:gservice5/pages/application/item/applicationItem.dart';
import 'package:gservice5/pages/application/list/customer/emptyApplicationListPage.dart';
import 'package:gservice5/pages/auth/registration/business/changedActivityBusinessPage.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActivityApplicationListPage extends StatefulWidget {
  const ActivityApplicationListPage({super.key});

  @override
  State<ActivityApplicationListPage> createState() =>
      _ActivityApplicationListPageState();
}

class _ActivityApplicationListPageState
    extends State<ActivityApplicationListPage>
    with AutomaticKeepAliveClientMixin {
  List data = [];
  bool loader = true;
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  RefreshController refreshController = RefreshController();
  ScrollController scrollController = ScrollController();
  bool filledActivity = false;

  @override
  void initState() {
    getData();
    scrollController.addListener(() => loadMoreAd());
    super.initState();
  }

  @override
  void dispose() {
    FilterData.data.clear();
    scrollController.dispose();
    refreshController.dispose();
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
      Response response = await dio.get("/activity-applications");
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        filledActivity = response.data['filled_activity'];
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
    refreshController.refreshCompleted();
  }

  void loadMoreAd() async {
    if (scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Response response = await dio
            .get("/activity-applications", data: {"page": page.toString()});
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

  void filteredAds(value) {
    if (value != null) {
      // param = FilterData.data;
      getData();
    }
  }

  void showPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ChangedActivityBusinessPage())).then((value) {
      if (value == "update") getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return loader
        ? const AdListLoader()
        : SmartRefresher(
            onRefresh: () async {
              await getData();
            },
            enablePullDown: true,
            enablePullUp: false,
            controller: refreshController,
            header: MaterialClassicHeader(
                color: ColorComponent.mainColor, backgroundColor: Colors.white),
            child: !filledActivity
                ? EmptyActivityPage(showPage: showPage)
                : data.isEmpty
                    ? const EmptyApplicationListPage()
                    : ListView.builder(
                        itemCount: data.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: scrollController,
                        itemBuilder: (context, int index) {
                          Map value = data[index];
                          if (data.length - 1 == index) {
                            return Column(children: [
                              ApplicationItem(data: value, showCategory: true),
                              hasNextPage
                                  ? const PaginationLoaderComponent()
                                  : Container()
                            ]);
                          } else {
                            return ApplicationItem(
                                data: value, showCategory: true);
                          }
                        }));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class EmptyActivityPage extends StatelessWidget {
  final VoidCallback showPage;
  const EmptyActivityPage({super.key, required this.showPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/icons/portfolio.svg",
            width: 120, color: ColorComponent.gray['500']),
        const Divider(indent: 12),
        const Text("Деятельность толтырыныз",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const Divider(height: 20),
        Button(
            onPressed: showPage,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            title: "Заполнить вид деятельности"),
        const Divider(height: 100),
      ],
    );
  }
}
