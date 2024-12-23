import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/fadeOnScroll.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
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
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/ad/list/adListPage.dart';
import 'package:gservice5/pages/author/filesListPage.dart';
import 'package:readmore/readmore.dart';

class ViewContractorPage extends StatefulWidget {
  final int id;
  const ViewContractorPage({super.key, required this.id});

  @override
  State<ViewContractorPage> createState() => _ViewContractorPageState();
}

class _ViewContractorPageState extends State<ViewContractorPage> {
  Map data = {};
  bool loader = true;
  List childData = [
    {"page": FilesListPage(), "title": "Подписчики"},
    {"page": FilesListPage(), "title": "Отзывы"},
    {"page": FilesListPage(), "title": "Файлы"},
  ];
  List categories = CategoriesData.categories;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    getData();
    getCategories();
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

  String daysBetween() {
    DateTime from = DateTime.parse(data['created_at']);
    DateTime to = DateTime.now();
    int days = to.difference(from).inDays;
    if (days < 27) {
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
        leading: BackIconButton(),
        actions: [ShareButton(id: 0, hasAd: false), Divider(indent: 15)],
        title: loader
            ? Container()
            : FadeOnScroll(
                scrollController: scrollController,
                fullOpacityOffset: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width / 1.5),
                            child: Text(data['name'],
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600))),
                        const Divider(indent: 6),
                        SvgPicture.asset("assets/icons/badgeCheck.svg",
                            width: 18),
                      ],
                    ),
                    const Divider(height: 2),
                    Text(daysBetween().toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: ColorComponent.gray['500'])),
                    // PriceTextWidget(prices: data['price'], fontSize: 14)
                  ],
                ),
              ),
      ),
      body: loader
          ? LoaderComponent()
          : DefaultTabController(
              length: categories.length,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 7),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CacheImage(
                                        url: data['avatar'],
                                        width: 70,
                                        height: 70,
                                        borderRadius: 10),
                                    const Divider(indent: 16),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.5),
                                                child: Text(data['name'],
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600))),
                                            const Divider(indent: 6),
                                            SvgPicture.asset(
                                                "assets/icons/badgeCheck.svg"),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(daysBetween().toString(),
                                                style: TextStyle(
                                                    color: ColorComponent
                                                        .gray['500'])),
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                  color:
                                                      ColorComponent.mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/star.svg'),
                                                  const Divider(indent: 2),
                                                  Text(
                                                      data['rating'].toString(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600))
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ReadMoreText(
                                      "Севало Инжиниринг Машинери Казахстан)» создано в Казахстане (г.Алматы) в Мае, 2012 года.Наша компания в основном реализует продукцию Южной Кореи (экскаватор, погрузчик, дробилка), Шаньдунской компании Линь Гун Китай (погрузчики), Уханьской компании Шань Мао, Китай (Bobcat), Шанхайской компании Хань Юй Китай, (гидромолот) и других известных компаний.Компания предоставляет клиентам комплексное обслуживание как реализация, сервисное обслуживание машин, управление финансирования и страховое агентство. Компания всегда придерживается идеи бизнеса комплексное обслуживание и высокое качество, а также принципов - честность, искренний труд, и непреклонное стремление к совершенству",
                                      trimMode: TrimMode.Line,
                                      trimLines: 3,
                                      trimCollapsedText: ' Показать больше',
                                      trimExpandedText: ' Cкрыть',
                                      lessStyle: TextStyle(
                                          fontSize: 14,
                                          color: ColorComponent.blue['500'],
                                          fontWeight: FontWeight.w500),
                                      moreStyle: TextStyle(
                                          fontSize: 14,
                                          color: ColorComponent.blue['500'],
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 40,
                              //   child: SingleChildScrollView(
                              //     padding: EdgeInsets.symmetric(horizontal: 15),
                              //     scrollDirection: Axis.horizontal,
                              //     child: Row(
                              //         children: childData.map((value) {
                              //       return GestureDetector(
                              //         onTap: () {
                              //           showPage(value);
                              //         },
                              //         child: Container(
                              //             height: 32,
                              //             padding: const EdgeInsets.symmetric(
                              //                 horizontal: 12),
                              //             margin: const EdgeInsets.symmetric(
                              //                 horizontal: 4),
                              //             alignment: Alignment.center,
                              //             decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(8),
                              //                 color: ColorComponent.mainColor
                              //                     .withOpacity(.2)),
                              //             child: Text(value['title'],
                              //                 style: const TextStyle(
                              //                     fontSize: 12,
                              //                     fontWeight: FontWeight.w400,
                              //                     height: 1))),
                              //       );
                              //     }).toList()),
                              //   ),
                              // ),
                              InfoButton(
                                  SvgPicture.asset(
                                      'assets/icons/starOutline.svg',
                                      width: 18,
                                      color: Color(0xff6b7280)),
                                  "4.92 рейтинг",
                                  () {}),
                              InfoButton(
                                  SvgPicture.asset('assets/icons/users.svg',
                                      width: 18, color: Color(0xff6b7280)),
                                  "${numberFormat(1000)} подписчиков",
                                  () {}),
                              InfoButton(
                                  SvgPicture.asset('assets/icons/pin.svg',
                                      width: 18, color: Color(0xff6b7280)),
                                  data['city']['title'],
                                  () {}),
                              InfoButton(
                                  Container(
                                      width: 8,
                                      height: 8,
                                      margin:
                                          EdgeInsets.only(right: 4, left: 5),
                                      decoration: BoxDecoration(
                                          color: ColorComponent.red['500'],
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  "Закрыто до завтра",
                                  () {}),

                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 15, vertical: 12),
                              //   child: Row(
                              //     children: [
                              //       Expanded(
                              //         child: Row(
                              //           children: [
                              //             SvgPicture.asset(
                              //                 'assets/icons/pin.svg',
                              //                 width: 18,
                              //                 color: Color(0xff6b7280)),
                              //             Divider(indent: 6),
                              //             Text(data['city']['title'],
                              //                 style: TextStyle(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500)),
                              //           ],
                              //         ),
                              //       ),
                              //       SvgPicture.asset("assets/icons/right.svg")
                              //     ],
                              //   ),
                              // ),
                              Divider(height: 10),
                              SizedBox(
                                height: 40,
                                child: Button(
                                  onPressed: () {},
                                  title: "Подписаться",
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                ),
                              ),
                              Divider(height: 10),
                            ]),
                      ),
                      SliverAppBar(
                        pinned: true,
                        toolbarHeight: 0,
                        bottom: PreferredSize(
                          preferredSize:
                              Size(MediaQuery.of(context).size.width, 51),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    // top: BorderSide(
                                    //     width: 1, color: Color(0xfff4f5f7)),
                                    bottom: BorderSide(
                                        width: 2, color: Color(0xfff4f5f7)))),
                            child: TabBar(
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                tabs: categories.map((value) {
                                  return Tab(text: value['title']);
                                }).toList()),
                          ),
                        ),
                      ),

                      // SliverStickyHeader(
                      //     header: Container(
                      //       color: Colors.white,
                      //       child: TabBar(
                      //           isScrollable: true,
                      //           tabAlignment: TabAlignment.start,
                      //           tabs: categories.map((value) {
                      //             return Tab(text: value['title']);
                      //           }).toList()),
                      //     ),
                      //     sliver: SliverList(
                      //       delegate: SliverChildBuilderDelegate(
                      //         (context, i) => ListTile(
                      //           leading: CircleAvatar(
                      //             child: Text('0'),
                      //           ),
                      //           title: Text('List tile #$i'),
                      //         ),
                      //         childCount: 4,
                      //       ),
                      //       // ),
                      //     )),
                    ];
                  },
                  body: TabBarView(
                    children: categories.map((value) {
                      return ListView.builder(
                        itemCount: 40,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text('0'),
                            ),
                            title: Text('List tile #$index'),
                          );
                        },
                      );
                    }).toList(),
                  )),
            ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
                child: Button(
                    onPressed: () {},
                    backgroundColor: ColorComponent.mainColor.withOpacity(.1),
                    title: "Соц. сети")),
            const Divider(indent: 8),
            Expanded(
                child: Button(
                    onPressed: () {}, icon: "phone.svg", title: "Позвонить"))
          ],
        ),
      )),
    );
  }

  Widget InfoButton(Widget leading, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  leading,
                  Divider(indent: 10),
                  Text(title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            SvgPicture.asset("assets/icons/right.svg")
          ],
        ),
      ),
    );
  }
}
