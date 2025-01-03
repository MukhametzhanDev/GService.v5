import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/filter/filterButton.dart';
import 'package:gservice5/pages/companies/companyItem.dart';
import 'package:gservice5/pages/companies/createCompanyWidget.dart';
import 'package:gservice5/pages/profile/news/newsItem.dart';

class CompaniesMainPage extends StatefulWidget {
  const CompaniesMainPage({super.key});

  @override
  State<CompaniesMainPage> createState() => _CompaniesMainPageState();
}

class _CompaniesMainPageState extends State<CompaniesMainPage> {
  List data = [];
  bool loader = true;
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    getData();
    scrollController.addListener(() {
      loadMoreAd();
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void showLoader() {
    if (!loader) {
      loader = true;
      setState(() {});
    }
  }

  Future getData() async {
    try {
      page = 1;
      showLoader();
      Response response = await dio.get("/companies");
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void loadMoreAd() async {
    if (scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Response response = await dio
            .get("/companies", queryParameters: {"page": page.toString()});
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [FilterButton(showFilterPage: () {})],
          leading: BackTitleButton(title: "Компании"),
          leadingWidth: 150),
      body: ListView.builder(
        controller: scrollController,
        itemCount: data.length,
        itemBuilder: (context, index) {
          Map item = data[index];
          if (data.length - 1 == index) {
            return Column(
              children: [
                CompanyItem(data: item),
                CreateCompanyWidget(),
                hasNextPage ? const PaginationLoaderComponent() : Container()
              ],
            );
          } else {
            // if (index > 14 && index % 15 == 0) {
            //   return Column(
            //     children: [CreateCompanyWidget(), CompanyItem(data: item)],
            //   );
            // } else {
            return CompanyItem(data: item);
            // }
          }
        },
      ),
    );
  }
}
