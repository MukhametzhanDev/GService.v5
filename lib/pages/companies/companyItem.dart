import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/author/business/viewBusinessPage.dart';

class CompanyItem extends StatelessWidget {
  final Map data;
  const CompanyItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    List categories = data['categories'];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewBusinessPage(id: data['id'])));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 6, color: Color(0xfff4f5f7)))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CacheImage(
                    url: data['avatar'],
                    width: 70,
                    height: 52,
                    borderRadius: 8),
                const Divider(indent: 10),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width / 1.5),
                            child: Text(data['name'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600))),
                        const Divider(indent: 6),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: SvgPicture.asset("assets/icons/badgeCheck.svg",
                              width: 18),
                        )
                      ],
                    ),
                    const Divider(height: 3),
                    Text(data['city']['title'],
                        style: TextStyle(color: ColorComponent.gray['500']))
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
                )),
              ],
            ),
            categories.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.black, fontSize: 14, height: 1.4),
                          children: categories.map((value) {
                            int index = categories.indexOf(value);
                            String last =
                                index == categories.length - 1 ? "" : ", ";
                            return TextSpan(text: value["title"] + last);
                          }).toList()),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: ColorComponent.mainColor.withOpacity(.2),
                        borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/star.svg'),
                        const Divider(indent: 2),
                        Text(data['rating'].toString(),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600))
                      ],
                    ),
                  ),
                  const Divider(indent: 8),
                  const Text("88 отзывов")
                ],
              ),
            ),
            // data['description'] == null
            //     ? Container()
            //     : Padding(
            //         padding: const EdgeInsets.only(top: 12.0),
            //         child: Text(data['description'] ?? "",
            //             style: const TextStyle(height: 1.6),
            //             maxLines: 2,
            //             overflow: TextOverflow.ellipsis),
            //       ),
          ],
        ),
      ),
    );
  }
}
