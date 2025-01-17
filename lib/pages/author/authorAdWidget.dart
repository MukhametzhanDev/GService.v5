import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/author/authorAdsListWidget.dart';
import 'package:gservice5/pages/author/authorApplicationListWidget.dart';
import 'package:gservice5/pages/author/business/viewBusinessPage.dart';
import 'package:gservice5/pages/author/customer/viewCustomerPage.dart';

class AuthorAdWidget extends StatefulWidget {
  final String title;
  final Map data;
  final bool showOtherAd;
  final String? fromPage;

  final int id;
  final type;
  final subTitle;
  const AuthorAdWidget(
      {super.key,
      required this.title,
      required this.data,
      required this.id,
      this.type,
      this.subTitle,
      required this.showOtherAd,
      this.fromPage});

  @override
  State<AuthorAdWidget> createState() => _AuthorAdWidgetState();
}

class _AuthorAdWidgetState extends State<AuthorAdWidget> {
  final analytics = FirebaseAnalytics.instance;

  List data = [];
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    print("DATA ${widget.data}");
    try {
      Response response = await dio.get("/other-author-ads/${widget.id}");
      if (response.data['success']) {
        data = response.data['data'];
        loading = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void showPage() {
    if (widget.data['is_company']) {
      showViewCompanyPage();
    } else {
      showViewCustomerPage();
    }
  }

  void showViewCompanyPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewBusinessPage(id: widget.data['id'])));

    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.btnOwnerAd,
      GAKey.authorId: widget.data['id'].toString(),
      GAKey.isCompany: widget.data['is_company']
    }).catchError((e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    });
  }

  void showViewCustomerPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewCustomerPage(id: widget.data['id'])));
  }

  // String daysBetween() {
  //   DateTime from = DateTime.parse(data['created_at']);
  //   DateTime to = DateTime.now();
  //   int days = to.difference(from).inDays;
  //   if (days < 27) {
  //     return "$days дней на GService.kz";
  //   } else if (days > 27 && days < 365) {
  //     int month = (days / 27).round();
  //     return "$month месяцев на GService.kz";
  //   } else {
  //     int year = (days / 365).round();
  //     return "$year лет на GService.kz";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 16, left: 16),
                child: Text(widget.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600))),
        GestureDetector(
          onTap: () => showPage(),
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorComponent.gray['100']),
            child: widget.data['is_company']
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CacheImage(
                              url: widget.data['avatar'],
                              width: 48,
                              height: 48,
                              borderRadius: 6),
                          const Divider(indent: 16),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5),
                                      child: Text(widget.data['name'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600))),
                                  const Divider(indent: 6),
                                  SvgPicture.asset(
                                      "assets/icons/badgeCheck.svg")
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ID: ${widget.data['id']}",
                                      style: TextStyle(
                                          color: ColorComponent.gray['500'])),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: ColorComponent.mainColor,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/star.svg'),
                                        const Divider(indent: 2),
                                        const Text("4.92",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ))
                        ],
                      ),
                      const Divider(height: 12),
                      // Row(
                      //   children: [
                      //     Container(
                      //         height: 24,
                      //         padding: EdgeInsets.symmetric(horizontal: 8),
                      //         alignment: Alignment.center,
                      //         decoration: BoxDecoration(
                      //             color: ColorComponent.mainColor,
                      //             borderRadius: BorderRadius.circular(6)),
                      //         child: Text("Аренда",
                      //             style: TextStyle(
                      //                 height: 1,
                      //                 fontSize: 12,
                      //                 fontWeight: FontWeight.w600))),
                      //     Divider(indent: 8),
                      //   ],
                      // ),
                      // Divider(height: 12),
                      const Text("Официальный диллер"),
                      // const Divider(height: 12),
                      // const Text("Контакты",
                      //     style: TextStyle(
                      //         fontSize: 16, fontWeight: FontWeight.w600)),
                      // const Divider(height: 12),
                      // GestureDetector(
                      //   child: const Row(children: [
                      //     Text("example.com",
                      //         style: TextStyle(
                      //             decoration: TextDecoration.underline))
                      //   ]),
                      // ),
                      // const Divider(height: 12),
                      // GestureDetector(
                      //   child: const Row(children: [
                      //     Text("Написать на whatsapp",
                      //         style: TextStyle(
                      //             decoration: TextDecoration.underline))
                      //   ]),
                      // ),
                      // const Divider(height: 12),
                      // GestureDetector(
                      //   child: const Row(children: [
                      //     Text("@instagramnik",
                      //         style: TextStyle(
                      //             decoration: TextDecoration.underline))
                      //   ]),
                      // ),
                      const Divider(height: 12),
                      SizedBox(
                          height: 41,
                          child: Button(
                              onPressed: showViewCompanyPage,
                              backgroundColor: ColorComponent.mainColor,
                              title: "Страница продавца"))
                    ],
                  )
                : Row(children: [
                    CacheImage(
                        url: widget.data['avatar'],
                        width: 48,
                        height: 48,
                        borderRadius: 6),
                    const Divider(indent: 16),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.data['name'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const Divider(height: 3),
                        Text("ID: ${widget.data['id']}",
                            style: TextStyle(color: ColorComponent.gray['500']))
                      ],
                    )),
                    SvgPicture.asset("assets/icons/right.svg"),
                    const Divider(indent: 8)
                  ]),
          ),
        ),
        widget.showOtherAd
            ? widget.type == "ad"
                ? AuthorAdsListWidget(
                    id: widget.id,
                    subTitle: widget.subTitle,
                    showPage: showPage)
                : AuthorApplicationListWidget(
                    id: widget.id,
                    subTitle: widget.subTitle,
                    showPage: showPage)
            : Container(),
      ],
    );
  }
}
