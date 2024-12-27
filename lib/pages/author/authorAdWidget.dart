import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/item/smallAdItem.dart';
import 'package:gservice5/pages/author/contractor/viewContractorPage.dart';
import 'package:gservice5/pages/author/individual/viewIndiviualPage.dart';

class AuthorAdWidget extends StatefulWidget {
  final String title;
  final Map data;
  const AuthorAdWidget({super.key, required this.title, required this.data});

  @override
  State<AuthorAdWidget> createState() => _AuthorAdWidgetState();
}

class _AuthorAdWidgetState extends State<AuthorAdWidget> {
  void showPage() {
    if (widget.data['is_company']) {
      showViewCompanyPage();
    } else {
      showViewIndividualPage();
    }
  }

  void showViewCompanyPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewContractorPage(id: widget.data['id'])));
  }

  void showViewIndividualPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewIndividualPage(id: widget.data['id'])));
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
                color: const Color(0xfff4f4f4)),
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
        const Divider(height: 16),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Другие объявления продавца",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
        const Divider(height: 12),
        SizedBox(
          height: MediaQuery.of(context).size.width / 2.3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            child: Row(
                children: [1, 2, 3].map((value) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SmallAdItem(index: value, showFullInfo: false),
              );
            }).toList()),
          ),
        )
      ],
    );
  }
}
