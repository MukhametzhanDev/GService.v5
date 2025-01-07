import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/bar/bottomBar/contactBottomBarWidget.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/categories/data/categoriesData.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/formatted/number/numberFormatted.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/request/getCategories.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/list/adListWidget.dart';
import 'package:gservice5/pages/application/list/applicationListWidget.dart';
import 'package:gservice5/pages/author/business/viewAboutBusinessPage.dart';
import 'package:gservice5/pages/author/filesListPage.dart';
import 'package:gservice5/pages/profile/news/newsList.dart';

class ViewBusinessPage extends StatefulWidget {
  final int id;
  const ViewBusinessPage({super.key, required this.id});

  @override
  State<ViewBusinessPage> createState() => _ViewBusinessPageState();
}

class _ViewBusinessPageState extends State<ViewBusinessPage>
    with SingleTickerProviderStateMixin {
  Map data = {};
  bool loader = true;
  List childData = [
    {"page": const FilesListPage(), "title": "Подписчики"},
    {"page": const FilesListPage(), "title": "Отзывы"},
    {"page": const FilesListPage(), "title": "Файлы"},
  ];
  List pages = [
    {"title": "О компании"},
    {"title": "Объявления"},
    {"title": "Заказы"},
    {"title": "Новости"},
    {"title": "Сертфикаты"},
  ];
  List categories = CategoriesData.categories;
  ScrollController scrollController = ScrollController();
  TabController? tabController;

  @override
  void initState() {
    getData();
    getCategories();
    tabController = TabController(length: pages.length, vsync: this);
    super.initState();
  }

  Future getCategories() async {
    if (categories.isEmpty) {
      categories = await GetCategories().getData(context);
    }
    setState(() {});
  }

  Future getData() async {
    try {
      Response response = await dio.get("/company/${widget.id}");
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

  void showPage(value) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => value['page']));
  }

  void changedAdTab() {
    tabController!.animateTo(1);
  }

  String daysBetween() {
    DateTime from = DateTime.parse(data['created_at']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width - 100,
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style:
                const ButtonStyle(tapTargetSize: MaterialTapTargetSize.padded),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: loader
                ? Container()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Divider(indent: 15),
                      SvgPicture.asset('assets/icons/left.svg', width: 28),
                      const Divider(indent: 10),
                      Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width / 1.7),
                          child: Text(
                            data['name'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                      const Divider(indent: 6),
                      SvgPicture.asset("assets/icons/badgeCheck.svg"),
                    ],
                  ),
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
                                      horizontal: 15, vertical: 7),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CacheImage(
                                          url: data['avatar'],
                                          width: 70,
                                          height: 70,
                                          borderRadius: 40),
                                      const Divider(indent: 16),
                                      ButtonInfo("users.svg", "Подписчиков",
                                          numberFormat(1200), () {}),
                                      ButtonInfo("file.svg", "Объявлении",
                                          numberFormat(1200), changedAdTab),
                                      ButtonInfo(
                                          "starOutline.svg",
                                          "143 отзывов",
                                          data['rating'].toString(),
                                          () {}),
                                    ],
                                  ),
                                ),
                                const Divider(height: 7),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(daysBetween()),
                                ),
                                const Divider(height: 15),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  height: 40,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Button(
                                            onPressed: () {},
                                            backgroundColor: ColorComponent
                                                .mainColor
                                                .withOpacity(.2),
                                            title: "Поделится"),
                                      ),
                                      const Divider(indent: 10),
                                      Expanded(
                                        child: Button(
                                            onPressed: () {},
                                            title: "Подписаться"),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 10),
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
                                  isScrollable: true,
                                  tabAlignment: TabAlignment.start,
                                  tabs: pages.map((value) {
                                    return Tab(text: value['title']);
                                  }).toList()),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(controller: tabController, children: [
                      ViewAboutBusinessPage(data: data),
                      AdListWidget(param: {
                        "author_id": widget.id,
                        "author_type": "company"
                      }, scrollController: scrollController),
                      ApplicationListWidget(param: {
                        "author_id": widget.id,
                        "author_type": "company"
                      }, scrollController: scrollController),
                      NewsList(
                          param: {"company_id": widget.id},
                          scrollController: scrollController),
                      const FilesListPage()
                    ])),
              ),
        bottomNavigationBar: loader
            ? const SizedBox.shrink()
            : const ContactBottomBarWidget(hasAd: false, id: 1, phones: []));
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
