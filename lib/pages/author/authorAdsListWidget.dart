import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/item/smallAdItem.dart';
import 'package:shimmer/shimmer.dart';

class AuthorAdsListWidget extends StatefulWidget {
  final int id;
  final String subTitle;
  final VoidCallback showPage;
  const AuthorAdsListWidget(
      {super.key,
      required this.id,
      required this.subTitle,
      required this.showPage});

  @override
  State<AuthorAdsListWidget> createState() => _AuthorAdsListWidgetState();
}

class _AuthorAdsListWidgetState extends State<AuthorAdsListWidget> {
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
    double itemWidth = MediaQuery.of(context).size.width / 2;
    return Column(children: [
      data.isEmpty
          ? Container(height: 10)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 16),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(widget.subTitle ?? "",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600))),
                const Divider(height: 12),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 2.3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    scrollDirection: Axis.horizontal,
                    child: loading
                        ? Row(
                            children: [1, 2].map((value) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Shimmer.fromColors(
                                  baseColor: const Color(0xffD1D5DB),
                                  highlightColor: const Color(0xfff4f5f7),
                                  period: const Duration(seconds: 1),
                                  child: Container(
                                      width: itemWidth - 24,
                                      height: itemWidth - 2,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)))),
                            );
                          }).toList())
                        : Row(
                            children: data.map((value) {
                            int index = data.indexOf(value);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: data.length > 3 && data.length - 1 == index
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          SmallAdItem(
                                              data: value, showFullInfo: false),
                                          const Divider(indent: 15),
                                          GestureDetector(
                                            onTap: () => widget.showPage(),
                                            child: Container(
                                              width: 140,
                                              height: itemWidth / 1.7,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: ColorComponent
                                                      .mainColor
                                                      .withOpacity(.2)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      "assets/icons/searchOutline.svg",
                                                      width: 32),
                                                  const Divider(height: 6),
                                                  const Text("Посмотреть все",
                                                      textAlign:
                                                          TextAlign.center)
                                                ],
                                              ),
                                            ),
                                          )
                                        ])
                                  : SmallAdItem(
                                      data: value, showFullInfo: false),
                            );
                          }).toList()),
                  ),
                )
              ],
            )
    ]);
  }
}