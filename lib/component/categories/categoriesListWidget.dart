import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/categories/request/getCategories.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/categories/data/categoriesData.dart';
import 'package:gservice5/pages/ad/list/adListPage.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesListWidget extends StatefulWidget {
  const CategoriesListWidget({super.key});

  @override
  State<CategoriesListWidget> createState() => _CategoriesListWidgetState();
}

class _CategoriesListWidgetState extends State<CategoriesListWidget> {
  List data = [];
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    data = await GetCategories().getData(context);
    loader = false;
    setState(() {});
  }

  void showPage(Map value) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AdListPage(category: value)));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          child: loader
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(10, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Shimmer.fromColors(
                          baseColor: Color(0xffD1D5DB),
                          highlightColor: Color(0xfff4f5f7),
                          period: Duration(seconds: 1),
                          child: Container(
                              width: 60,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)))),
                    );
                  }))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: data.map((value) {
                    int index = data.indexOf(value);
                    if (index == 0) {
                      return Row(
                        children: [
                          Container(
                              height: 30,
                              // constraints: BoxConstraints(maxWidth: 150,minWidth: 40),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1,
                                      color: ColorComponent.mainColor)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset('assets/icons/pin.svg',
                                      color: Colors.black, width: 16),
                                  Divider(indent: 4),
                                  Text("Все города",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          height: 1)),
                                ],
                              )),
                          CategoryButton(value)
                        ],
                      );
                    }
                    return CategoryButton(value);
                  }).toList()),
        ));
  }

  Widget CategoryButton(value) {
    return GestureDetector(
      onTap: () {
        showPage(value);
      },
      child: Container(
          height: 32,
          padding: EdgeInsets.symmetric(horizontal: 12),
          margin: EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorComponent.mainColor.withOpacity(.2)),
          child: Text(value['title'],
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w400, height: 1))),
    );
  }
}
