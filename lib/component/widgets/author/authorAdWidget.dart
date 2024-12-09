import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class AuthorAdWidget extends StatefulWidget {
  final String title;
  final Map data;
  const AuthorAdWidget({super.key, required this.title, required this.data});

  @override
  State<AuthorAdWidget> createState() => _AuthorAdWidgetState();
}

class _AuthorAdWidgetState extends State<AuthorAdWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.data['is_company']
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.title.isEmpty
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(widget.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600))),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xfff4f4f4)),
                child: Column(
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
                        Divider(indent: 16),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                1.5),
                                    child: Text(widget.data['name'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600))),
                                Divider(indent: 6),
                                SvgPicture.asset("assets/icons/badgeCheck.svg"),
                              ],
                            ),
                            Divider(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("БИН: 1234 1234 1234",
                                    style: TextStyle(
                                        color: ColorComponent.gray['500'])),
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: ColorComponent.mainColor,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/icons/star.svg'),
                                      Divider(indent: 2),
                                      Text("4.92",
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
                    Divider(indent: 12),
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
                    RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(text: "Город: "),
                              TextSpan(
                                  text: "Алматы",
                                  style: TextStyle(fontWeight: FontWeight.w600))
                            ])),
                    Divider(height: 12),
                    Text("Контакты",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Divider(height: 12),
                    GestureDetector(
                      child: Row(children: [
                        Text("example.com",
                            style:
                                TextStyle(decoration: TextDecoration.underline))
                      ]),
                    ),
                    Divider(height: 12),
                    GestureDetector(
                      child: Row(children: [
                        Text("Написать на whatsapp",
                            style:
                                TextStyle(decoration: TextDecoration.underline))
                      ]),
                    ),
                    Divider(height: 12),
                    GestureDetector(
                      child: Row(children: [
                        Text("@instagramnik",
                            style:
                                TextStyle(decoration: TextDecoration.underline))
                      ]),
                    ),
                    Divider(height: 12),
                    SizedBox(
                        height: 41,
                        child: Button(
                            onPressed: () {},
                            backgroundColor: ColorComponent.mainColor,
                            title: "Еще 123 объявления"))
                  ],
                ),
              ),
            ],
          )
        : Container();
  }
}
