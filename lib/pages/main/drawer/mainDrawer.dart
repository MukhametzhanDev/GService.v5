import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/leadingLogo.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/data/categoriesData.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List categories = CategoriesData.categories;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width - 75,
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 160,
            leading: LeadingLogo(),
            actions: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorComponent.mainColor.withOpacity(.1)),
                  child: SvgPicture.asset('assets/icons/close.svg',
                      color: Colors.black),
                ),
              ),
              Divider(indent: 15)
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categories.map((value) {
                      return Container(
                        height: 36,
                        margin: EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/icons/${value['icon']}",
                                width: 24),
                            Divider(indent: 8),
                            Text(
                              value['full_title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    }).toList())
              ],
            ),
          ),
        ));
  }
}
