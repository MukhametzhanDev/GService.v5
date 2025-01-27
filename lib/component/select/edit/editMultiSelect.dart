import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/select/multi/multiSelectPaginationModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditMultiSelect extends StatefulWidget {
  final String title;
  final String api;
  final List values;
  final Map option;
  const EditMultiSelect(
      {super.key,
      required this.title,
      required this.values,
      required this.option,
      required this.api});

  @override
  State<EditMultiSelect> createState() => _EditMultiSelectState();
}

class _EditMultiSelectState extends State<EditMultiSelect> {
  List data = [];
  Map currentData = {};

  @override
  void initState() {
    data = widget.values;
    super.initState();
  }

  void showModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => MultiSelectPaginationModal(
            api: widget.api,
            title: widget.title,
            onChanged: onChangedData,
            data: data));
  }

  void onChangedData(List value) {
    data = value;
    EditData.data.addAll({widget.option['name']: value});
    setState(() {});
  }

  void removedItem(int index) {
    data.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const Divider(height: 8),
        GestureDetector(
          onTap: showModal,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xffF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: const Color(0xffE5E5EA))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text("Выбрать",
                      style: TextStyle(
                          color: ColorComponent.gray['500'],
                          overflow: TextOverflow.ellipsis)),
                ),
                SvgPicture.asset('assets/icons/down.svg')
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: data.isEmpty ? 12 : 24),
          child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: data.map((value) {
                int index = data.indexOf(value);
                return GestureDetector(
                  onTap: () => removedItem(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 26,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            width: 1, color: ColorComponent.mainColor)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(value['title'],
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500)),
                        const Divider(indent: 4),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: SvgPicture.asset('assets/icons/close.svg',
                              width: 12, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                );
              }).toList()),
        )
      ],
    );
  }
}
