import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeTitleButton.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/checkBox/checkBoxWidget.dart';

class SortAdsModal extends StatefulWidget {
  const SortAdsModal({super.key});

  @override
  State<SortAdsModal> createState() => _SortAdsModalState();
}

class _SortAdsModalState extends State<SortAdsModal> {
  List data = [
    {"title": "По количеству просмотров"},
    {"title": "По количеству звонков"},
    {"title": "По количеству написавших"},
    {"title": "По количеству добавлено в избранное"},
    {"title": "По количеству поделившихся"}
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            leading: const CloseTitleButton(title: "Сортировка"),
            leadingWidth: 200,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Text(
                    "Очистить",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorComponent.blue['500']),
                  )),
              const Divider(indent: 10)
            ],
          ),
          Column(
              children: data.map((value) {
            return ListTile(
                onTap: () {},
                title: Text(value['title']),
                trailing: const CheckBoxWidget(active: false));
          }).toList()),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
