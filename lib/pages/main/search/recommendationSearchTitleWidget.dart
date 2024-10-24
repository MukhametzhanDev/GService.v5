import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  @override
  void initState() {
    widget.titleController.addListener(() {
      getData();
    });
    super.initState();
  }

  void getData() {}

  @override
  Widget build(BuildContext context) {
    return widget.titleController.text.trim().isEmpty
        ? Container()
        : Column(
            children: [
              Container(
                height: 45,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: ColorComponent.gray['300'],
                  // border: Border(
                  //     bottom: BorderSide(
                  //         width: 1, color: ColorComponent.gray200))
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Text("Рекомендации",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorComponent.gray['500'])),
              ),
              Column(
                children:
                    List.generate(10, (index) => index.toString()).map((value) {
                  return Container(
                      decoration: BoxDecoration(
                          // border: Border(
                          //     bottom: BorderSide(
                          //         width: 1, color: ColorComponent.gray200))
                          ),
                      child: ListTile(
                          onTap: () {
                            widget.getResult("SDLG");
                          },
                          contentPadding: EdgeInsets.only(
                              top: 0, bottom: 0, left: 16, right: 8),
                          leading: SvgPicture.asset('assets/icons/search.svg',
                              width: 18),
                          title: Text("SDLG",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400))));
                }).toList(),
              )
            ],
          );
  }
}
