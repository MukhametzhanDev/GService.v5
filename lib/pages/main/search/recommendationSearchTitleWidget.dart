import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class RecommendationSearchTitleWidget extends StatefulWidget {
  final TextEditingController titleController;
  final Function getResult;
  const RecommendationSearchTitleWidget(
      {super.key, required this.titleController, required this.getResult});

  @override
  State<RecommendationSearchTitleWidget> createState() =>
      _RecommendationSearchTitleWidgetState();
}

class _RecommendationSearchTitleWidgetState
    extends State<RecommendationSearchTitleWidget> {
  List data = [];

  @override
  void initState() {
    widget.titleController.addListener(() {
      getData();
    });
    super.initState();
  }

  void getData() async {
    String title = widget.titleController.text.trim();
    if (title.isEmpty) {
      data = [];
      setState(() {});
    } else {
      try {
        Response response = await dio
            .get("/search-recommendations", queryParameters: {"title": title});
        print(response.data);
        if (response.statusCode == 200) {
          data = response.data['data'];
          setState(() {});
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } on DioException catch (e) {
        print(e);
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.titleController.text.trim().isEmpty || data.isEmpty
        ? Container()
        : Column(
            children: [
              Container(
                height: 45,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: ColorComponent.gray['100']),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Text("Рекомендации",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorComponent.gray['500'])),
              ),
              Column(
                children: data.map((value) {
                  return Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 1, color: Color(0xffe5e7eb)))),
                      child: ListTile(
                          onTap: () {
                            widget.getResult(value);
                          },
                          contentPadding: const EdgeInsets.only(
                              top: 0, bottom: 0, left: 16, right: 8),
                          leading: SvgPicture.asset(
                              'assets/icons/searchOutline.svg',
                              color: ColorComponent.gray['500'],
                              width: 18),
                          title: Text(
                            value,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          )));
                }).toList(),
              )
            ],
          );
  }
}
