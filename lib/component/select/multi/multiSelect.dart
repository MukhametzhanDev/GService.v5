import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/select/multi/multiSelectModal.dart';
import 'package:gservice5/component/select/multi/multiSelectPaginationModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MultiSelect extends StatefulWidget {
  final String title;
  final String api;
  final void Function(List data) onChanged;
  final bool pagination;
  const MultiSelect(
      {super.key,
      required this.title,
      required this.onChanged,
      required this.pagination,
      required this.api});

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  List data = [];

  void showModal() {
    if (widget.pagination) {
      showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => MultiSelectPaginationModal(
              api: widget.api,
              title: widget.title,
              onChanged: onChangedData,
              data: data));
    } else {
      showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => MultiSelectModal(
              api: widget.api,
              title: widget.title,
              onChanged: onChangedData,
              data: data));
    }
  }

  void onChangedData(List value) {
    data = value;
    setState(() {});
    widget.onChanged(value);
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
        GestureDetector(
          onTap: showModal,
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
                color: Color(0xffF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Color(0xffE5E5EA))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(widget.title,
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
          padding: const EdgeInsets.only(top: 12.0, bottom: 12),
          child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: data.map((value) {
                int index = data.indexOf(value);
                return GestureDetector(
                  onTap: () => removedItem(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    height: 26,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(width: 1, color: Color(0xffE5E7EB))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(value['title'],
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500)),
                        Divider(indent: 4),
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
