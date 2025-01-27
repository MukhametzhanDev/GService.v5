import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/pages/ad/item/adItem.dart';
import 'package:gservice5/pages/ad/list/adListLoader.dart';

class AdListMain extends StatefulWidget {
  final ScrollController scrollController;
  final Map<String, dynamic> param;
  const AdListMain(
      {super.key, required this.scrollController, required this.param});

  @override
  State<AdListMain> createState() => _AdListMainState();
}

class _AdListMainState extends State<AdListMain> {
  List data = [];
  bool loader = true;
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;

  @override
  void initState() {
    getData();
    widget.scrollController.addListener(() => loadMoreAd());
    super.initState();
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
      Response response = await dio.get("/ad", queryParameters: widget.param);
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
    if (widget.scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        Response response = await dio.get("/ad",
            queryParameters: {"page": page.toString(), ...widget.param});
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
    return loader
        ? const SliverToBoxAdapter(child: AdListLoader())
        : SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
            Map value = data[index];
            if (data.length - 1 == index) {
              return Column(children: [
                AdItem(data: value),
                hasNextPage ? const PaginationLoaderComponent() : Container()
              ]);
            } else {
              return AdItem(data: value);
            }
          }, childCount: data.length));
  }
}
