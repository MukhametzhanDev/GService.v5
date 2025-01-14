import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';

class RecommendationAdList extends StatefulWidget {
  final int id;
  const RecommendationAdList({super.key, required this.id});

  @override
  State<RecommendationAdList> createState() => _RecommendationAdListState();
}

class _RecommendationAdListState extends State<RecommendationAdList> {
  List data = [];
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/other-author-ads/${widget.id}");
      if (response.data['success']) {
        data = response.data['data'];
        loading = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Вам могут понравится",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600))),
              const SizedBox(height: 15),
              GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.98,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: List.generate(10, (index) => index).map((value) {
                    return Container();
                    // SmallAdItem(index: value, showFullInfo: true);
                  }).toList())
            ],
          );
  }
}
