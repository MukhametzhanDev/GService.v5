import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/categories/data/categoriesData.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/item/smallAdItem.dart';
import 'package:gservice5/pages/ad/widget/sortAdWidget.dart';

class ResultSearchPage extends StatefulWidget {
  final String title;
  const ResultSearchPage({super.key, required this.title});

  @override
  State<ResultSearchPage> createState() => _ResultSearchPageState();
}

class _ResultSearchPageState extends State<ResultSearchPage> {
  List categories = CategoriesData.categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: Border(bottom: BorderSide(color: Color(0xfff4f5f7), width: 1)),
        leadingWidth: 0,
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              Container(
                  width: 30,
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/icons/left.svg', width: 26)),
              Divider(indent: 4),
              SvgPicture.asset("assets/icons/searchOutline.svg",
                  color: ColorComponent.gray['500']),
              Divider(indent: 6),
              Text(widget.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
            ],
          ),
        ),
        bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 90),
            child: Column(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: categories.map((value) {
                    return Container(
                      height: 36,
                      decoration: BoxDecoration(
                          color: ColorComponent.mainColor.withOpacity(.15),
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.only(left: 16, right: 12),
                      child: Row(
                        children: [
                          Text(value['title'],
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          Container(
                            margin: EdgeInsets.only(left: 6),
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                color: ColorComponent.red['500'],
                                borderRadius: BorderRadius.circular(20)),
                            child: Text('124',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          )
                        ],
                      ),
                    );
                  }).toList()),
                ),
                Divider(height: 2),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SortAdWidget(onChangedCity: (value) {}),
                        Row(children: [
                          GestureDetector(
                            child: Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: ColorComponent.mainColor),
                              child: SvgPicture.asset("assets/icons/sort.svg",
                                  width: 20, color: Colors.black),
                            ),
                          ),
                          Divider(indent: 12),
                          GestureDetector(
                            child: Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: ColorComponent.mainColor),
                              child: SvgPicture.asset("assets/icons/filter.svg",
                                  width: 20),
                            ),
                          )
                        ])
                      ]),
                )
              ],
            )),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Wrap(
          spacing: 12,
          children: List.generate(20, (index) => index).map((value) {
            return SmallAdItem(index: value);
          }).toList(),
        ),
      ),
    );
  }
}
