import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/pages/ad/filter/filterButton.dart';
import 'package:gservice5/pages/companies/companyItem.dart';
import 'package:gservice5/pages/companies/createCompanyWidget.dart';
import 'package:gservice5/pages/companies/filter/filterCompanyAppBarWidget.dart';
import 'package:gservice5/pages/create/data/createData.dart';

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
  Map<String, dynamic> param = FilterData.data;

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
    FilterData.data.clear();
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
      Response response = await dio.get("/companies", queryParameters: param);
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
        Response response = await dio.get("/companies",
            queryParameters: {"page": page.toString(), ...param});
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
      appBar: FilterCompanyAppBarWidget(
          appBar: AppBar(),
          onChanged: (value) {
            if (value == "update") getData();
          }),
      body: loader
          ? LoaderComponent()
          : ListView.builder(
              controller: scrollController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                Map item = data[index];
                if (data.length - 1 == index) {
                  return Column(
                    children: [
                      CompanyItem(data: item),
                      const CreateCompanyWidget(),
                      hasNextPage
                          ? const PaginationLoaderComponent()
                          : Container()
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
