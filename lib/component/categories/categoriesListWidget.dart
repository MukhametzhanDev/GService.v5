import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/categories/data/categoriesData.dart';
import 'package:gservice5/component/request/getCategories.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/list/adListPage.dart';
import 'package:gservice5/pages/application/list/customer/applicationListPage.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesListWidget extends StatefulWidget {
  const CategoriesListWidget({super.key});

  @override
  State<CategoriesListWidget> createState() => _CategoriesListWidgetState();
}

class _CategoriesListWidgetState extends State<CategoriesListWidget> {
  List data = CategoriesData.categories;
  bool loader = true;

  final analytics = GetIt.I<FirebaseAnalytics>();

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    if (data.isEmpty) {
      data = await GetCategories().getData(context);
    }
    loader = false;
    setState(() {});
  }

  void showAdPage(Map value) {
    if (value['id'] == 3) {
      analytics.logSelectContent(
          contentType: GAContentType.category,
          itemId: value['id'].toString(),
          parameters: {
            GAKey.screenName: GAParams.mainPage,
            GAKey.categoryName: value['title'] ?? '',
          }).catchError((e) {
        debugPrint(e);
      });

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ApplicationListPage()));
    } else {
      analytics.logSelectContent(
          contentType: GAContentType.category,
          itemId: value['id'].toString(),
          parameters: {
            GAKey.screenName: GAParams.mainPage,
            GAKey.categoryName: value['title']
          }).catchError((e) {
        debugPrint(e);
      });

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AdListPage(category: value)));
    }
  }

  void showApplicationPage() {
    Navigator.pushNamed(context, "ApplicationListPage");
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
                          baseColor: const Color(0xffD1D5DB),
                          highlightColor: const Color(0xfff4f5f7),
                          period: const Duration(seconds: 1),
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
                    // int index = data.indexOf(value);
                    return CategoryButton(value);
                  }).toList()),
        ));
  }

  Widget CategoryButton(value) {
    return GestureDetector(
      onTap: () {
        showAdPage(value);
      },
      child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorComponent.mainColor.withOpacity(.2)),
          child: Text(value['title'],
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w400, height: 1))),
    );
  }
}
