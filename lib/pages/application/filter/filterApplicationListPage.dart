import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/filter/filterSelectModal.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class FilterApplicationListPage extends StatefulWidget {
  const FilterApplicationListPage({super.key});

  @override
  State<FilterApplicationListPage> createState() =>
      _FilterApplicationListPageState();
}

class _FilterApplicationListPageState extends State<FilterApplicationListPage> {
  Map getParam(Map value) {
    return {};
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
            children: [
              FilterSelectModal(
                  title: "Разделы",
                  api: "/application-categories",
                  option: {"name": "category_id"},
                  value: FilterData.data['category_id'] ?? {},
                  param: getParam)
            ],
          ),
        ));
  }
}
