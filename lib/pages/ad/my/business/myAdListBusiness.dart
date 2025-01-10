import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';

class MyAdListBusiness extends StatefulWidget {
  const MyAdListBusiness({super.key});

  @override
  State<MyAdListBusiness> createState() => _MyAdListBusinessState();
}

class _MyAdListBusinessState extends State<MyAdListBusiness> {
  List data = [];
  bool loader = true;
  ScrollController scrollController = ScrollController();
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;

  Future getData() async {
    try {
      page = 1;
      setState(() {});
      Response response = await dio.get("/my-ads", queryParameters: {});
      if (response.data['success']) {
        data = response.data['data'];
        hasNextPage = page != response.data['meta']['last_page'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
    // refreshController.refreshCompleted();
  }

  Future loadMoreAd() async {
    if (scrollController.position.extentAfter < 200 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Map<String, dynamic> parameter = {
          "page": page,
          // "status": currentStatusAd
        };
        Response response =
            await dio.get("/my-ads", queryParameters: parameter);
        if (response.data['success']) {
          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});
        } else {
          SnackBarComponent()
              .showErrorMessage(response.data['message'], context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
      ],
    );
  }
}
