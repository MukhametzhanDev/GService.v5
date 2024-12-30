import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class CompaniesMainPage extends StatefulWidget {
  const CompaniesMainPage({super.key});

  @override
  State<CompaniesMainPage> createState() => _CompaniesMainPageState();
}

class _CompaniesMainPageState extends State<CompaniesMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackTitleButton(title: "Компании"), leadingWidth: 150),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: ColorComponent.gray['100']!))),
            child: Column(
              children: [
                Row(
                  children: [
                    CacheImage(
                        url:
                            "https://images.unsplash.com/photo-1606834330324-544ea3bf3015?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTAzfHxuaWtlfGVufDB8fDB8fHww",
                        width: 60,
                        height: 60,
                        borderRadius: 40),
                    Divider(indent: 10),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width /
                                            1.5),
                                child: Text("SDLG",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600))),
                            const Divider(indent: 6),
                            SvgPicture.asset("assets/icons/badgeCheck.svg",
                                width: 18)
                          ],
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(top: 8),
                        //   padding: const EdgeInsets.all(4),
                        //   decoration: BoxDecoration(
                        //       color: ColorComponent.mainColor,
                        //       borderRadius: BorderRadius.circular(4)),
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       SvgPicture.asset('assets/icons/star.svg'),
                        //       const Divider(indent: 2),
                        //       const Text("4.92",
                        //           style: TextStyle(
                        //               fontSize: 12,
                        //               fontWeight: FontWeight.w600))
                        //     ],
                        //   ),
                        // ),
                      ],
                    ))
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
