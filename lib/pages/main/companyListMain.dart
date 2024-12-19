import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class CompanyListMain extends StatefulWidget {
  const CompanyListMain({super.key});

  @override
  State<CompanyListMain> createState() => _CompanyListMainState();
}

class _CompanyListMainState extends State<CompanyListMain> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text("Топ компании",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, height: 1)),
        ),
        const Divider(indent: 12),
        SizedBox(
          height: 212,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: Row(
                children: [1, 2, 3].map((value) {
                  return Container(
                    height: 212,
                    width: 144,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: const Color(0xffeeeeee))),
                    child: Stack(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 4),
                            CacheImage(
                                url:
                                    "https://images.unsplash.com/photo-1531339094863-f764edf2eaad?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                width: 110,
                                height: 110,
                                borderRadius: 8),
                            Divider(indent: 8),
                            Text(
                              "OYAL ENERJİ JENERATÖR",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: ColorComponent.mainColor,
                                borderRadius: BorderRadius.circular(4)),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/star.svg'),
                                const Divider(indent: 2),
                                const Text("4.92",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              )),
        ),
      ],
    );
  }
}
