import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/pages/application/item/smallApplicationItem.dart';
import 'package:shimmer/shimmer.dart';

class RecommendationApplicationList extends StatefulWidget {
  const RecommendationApplicationList({super.key});

  @override
  State<RecommendationApplicationList> createState() =>
      _RecommendationApplicationListState();
}

class _RecommendationApplicationListState
    extends State<RecommendationApplicationList> {
  List data = [1, 2, 3];
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/application");
      if (response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void showPage(int id) {}

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Похожие заказы",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600))),
              const SizedBox(height: 15),
              loader
                  ? Column(
                      children: data.map((value) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 15),
                        child: Shimmer.fromColors(
                            baseColor: const Color(0xffD1D5DB),
                            highlightColor: const Color(0xfff4f5f7),
                            period: const Duration(seconds: 1),
                            child: Container(
                                width: MediaQuery.of(context).size.width - 30,
                                height: 110,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)))),
                      );
                    }).toList())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        Map item = data[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SmallApplicationItem(
                              onPressed: showPage,
                              data: item,
                              position: "more"),
                        );
                      },
                    )
            ],
          );
  }
}
