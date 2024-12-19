import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/select/selectModal.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Select extends StatefulWidget {
  final String title;
  final String api;
  final void Function(Map data) onChanged;
  final bool pagination;
  const Select(
      {super.key,
      required this.title,
      required this.onChanged,
      required this.pagination,
      required this.api});

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  Map data = {};

  void showModal() {
    if (widget.pagination) {
      // showCupertinoModalBottomSheet(
      //     context: context,
      //     builder: (context) => SelectPaginationModal(
      //         api: widget.api,
      //         title: widget.title,
      //         onChanged: onChangedData,
      //         data: data));
    } else {
      showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => SelectModal(
              api: widget.api,
              title: widget.title,
              onChanged: onChangedData,
              data: data));
    }
  }

  void onChangedData(Map value) {
    data = value;
    setState(() {});
    widget.onChanged(value);
  }

  void removedItem(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(widget.title,
        //     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        // Divider(height: 8),
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
                  child: Text(data.isEmpty ? widget.title : data['title'],
                      style: TextStyle(
                          color: data.isEmpty
                              ? ColorComponent.gray['500']
                              : Colors.black,
                          overflow: TextOverflow.ellipsis)),
                ),
                SvgPicture.asset('assets/icons/down.svg')
              ],
            ),
          ),
        ),
      ],
    );
  }
}
