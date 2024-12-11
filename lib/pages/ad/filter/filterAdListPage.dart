import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/ad/filter/filterSelectModal.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class FilterAdListPage extends StatefulWidget {
  final List data;
  const FilterAdListPage({super.key, required this.data});

  @override
  State<FilterAdListPage> createState() => _FilterAdListPageState();
}

class _FilterAdListPageState extends State<FilterAdListPage> {
  Map getParam(Map value) {
    print(value);
    int index = widget.data.indexOf(value);
    print("FilterData.data---> ${FilterData.data}");
    if (index <= 0 || index == widget.data.length - 1) {
      return {};
    } else {
      String key = widget.data[index - 1]?['name'] ?? "";
      Map param = {key: FilterData.data[key] ?? ""};
      return param;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackTitleButton(title: "Фильтр"),
        leadingWidth: 200,
        actions: [
          GestureDetector(
              onTap: () {
                FilterData.data.clear();
                Navigator.pop(context, "update");
              },
              child: Text("Сбросить",
                  style: TextStyle(
                      color: ColorComponent.blue['500'],
                      fontWeight: FontWeight.w500))),
          Divider(indent: 15)
        ],
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Column(
            children: widget.data.map((value) {
              return FilterSelectModal(
                  title: value['title']['title_ru'],
                  option: value,
                  api: value['url'],
                  param: getParam,
                  value: FilterData.data["${value['name']}_value"] ?? {});
            }).toList(),
          )),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Column(
        children: [
          Button(
              onPressed: () {
                Navigator.pop(context, "update");
              },
              title: "Поиск",
              padding: EdgeInsets.symmetric(horizontal: 15)),
        ],
      )),
    );
  }
}
