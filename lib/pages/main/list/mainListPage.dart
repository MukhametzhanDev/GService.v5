import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/leadingLogo.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/data/categoriesData.dart';
import 'package:gservice5/pages/ad/adList.dart';
import 'package:gservice5/pages/application/ApplicationList.dart';

class MainListPage extends StatefulWidget {
  const MainListPage({super.key});

  @override
  State<MainListPage> createState() => _MainListPageState();
}

class _MainListPageState extends State<MainListPage> {
  @override
  Widget build(BuildContext context) {
    List categories = CategoriesData.categories;
    return Scaffold(
      appBar: AppBar(
          actions: [
            GestureDetector(
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorComponent.mainColor.withOpacity(.1)),
                child: SvgPicture.asset('assets/icons/searchOutline.svg',
                    width: 24),
              ),
            ),
            Divider(indent: 15)
          ],
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 48),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 11),
                child: Row(
                    children: categories.map((value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(value,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          backgroundColor:
                              ColorComponent.mainColor.withOpacity(.1)),
                    ),
                  );
                }).toList()),
              ))),
      body: IndexedStack(children: [
        AdList(),
        ApplicationList(),
      ]),
    );
  }
}
