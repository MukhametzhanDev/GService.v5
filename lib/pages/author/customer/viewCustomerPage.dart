import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/bar/bottomBar/contactBottomBarWidget.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/list/adListWidget.dart';
import 'package:gservice5/pages/application/list/customer/applicationListWidget.dart';

class ViewCustomerPage extends StatefulWidget {
  final int id;
  const ViewCustomerPage({super.key, required this.id});

  @override
  State<ViewCustomerPage> createState() => _ViewCustomerPageState();
}

class _ViewCustomerPageState extends State<ViewCustomerPage>
    with SingleTickerProviderStateMixin {
  Map data = {};
  bool loader = true;
  List pages = [
    {"title": "Объявления"},
    {"title": "Заказы"},
  ];
  ScrollController scrollController = ScrollController();
  TabController? tabController;

  @override
  void initState() {
    getData();
    tabController = TabController(length: pages.length, vsync: this);
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/user/${widget.id}");
      if (response.statusCode == 200) {
        setState(() {
          data = response.data['data'];
          loader = false;
        });
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  String daysBetween() {
    DateTime from = DateTime.parse(
        // data['created_at']
        "2024-12-24T10:06:47.000000Z");
    DateTime to = DateTime.now();
    int days = to.difference(from).inDays;
    if (days < 27) {
      days = days == 0 ? 1 : days;
      return "$days дней на GService.kz";
    } else if (days > 27 && days < 365) {
      int month = (days / 27).round();
      return "$month месяцев на GService.kz";
    } else {
      int year = (days / 365).round();
      return "$year лет на GService.kz";
    }
  }

  void showPage(value) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => value['page']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackIconButton(),
          centerTitle: false,
          title: loader
              ? Container()
              : FadeOnScroll(
                  scrollController: scrollController,
                  fullOpacityOffset: 100,
                  child: Text(data['name'],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      textAlign: TextAlign.left,
                      maxLines: 1),
                ),
          actions: const [
            ShareButton(id: 0, hasAd: false),
            Divider(indent: 15)
          ],
        ),
        body: loader
            ? const LoaderComponent()
            : DefaultTabController(
                length: pages.length,
                child: NestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CacheImage(
                                          url: data['avatar'],
                                          width: 55,
                                          height: 55,
                                          borderRadius: 40),
                                      const Divider(indent: 16),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data['name'],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          Text(daysBetween(),
                                              style: TextStyle(
                                                  color: ColorComponent
                                                      .gray['500']))
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                        SliverAppBar(
                          pinned: true,
                          toolbarHeight: 0,
                          bottom: PreferredSize(
                            preferredSize:
                                Size(MediaQuery.of(context).size.width, 51),
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      // top: BorderSide(
                                      //     width: 1, color: Color(0xfff4f5f7)),
                                      bottom: BorderSide(
                                          width: 2, color: Color(0xfff4f5f7)))),
                              child: TabBar(
                                  controller: tabController,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: pages.map((value) {
                                    return Tab(text: value['title']);
                                  }).toList()),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(controller: tabController, children: [
                      AdListWidget(param: {
                        "author_id": widget.id,
                        "author_type": "user"
                      }, scrollController: scrollController),
                      ApplicationListWidget(param: {
                        "author_id": widget.id,
                        "author_type": "user"
                      }, scrollController: scrollController)
                    ])),
              ),
        bottomNavigationBar: ContactBottomBarWidget(
          hasAd: false,
          id: 1,
          phones: [data['phone']],
          fromPage: GAParams.viewCustomerPage,
        ));
  }

  Widget ButtonInfo(
      String icon, String title, String count, VoidCallback onPressed) {
    return Expanded(
      child: GestureDetector(
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/$icon',
                      width: 18, color: Colors.black),
                  const Divider(indent: 6),
                  Text(count,
                      style: const TextStyle(fontWeight: FontWeight.w500))
                ],
              ),
              const Divider(height: 6),
              Text(title,
                  style: TextStyle(
                      fontSize: 12, color: ColorComponent.gray['500'])),
            ],
          )),
    );
  }
}
