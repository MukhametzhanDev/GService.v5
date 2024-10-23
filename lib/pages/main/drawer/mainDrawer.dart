import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/appBar/leadingLogo.dart';
import 'package:gservice5/component/button/closeIconButton.dart';
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
    return ClipRRect(
      borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 75,
          child: Scaffold(
            appBar: AppBar(
              leadingWidth: 160,
              leading: LeadingLogo(),
              actions: [CloseIconButton(iconColor: null, padding: true)],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: categories.map((value) {
                        return Container(
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/icons/${value['icon']}"),
                              Text(value['title']),
                            ],
                          ),
                        );
                      }).toList())
                ],
              ),
            ),
          )),
    );
  }
}
