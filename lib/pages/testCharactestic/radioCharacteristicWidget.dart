import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class RadioCharacteristicWidget extends StatefulWidget {
  final Map value;
  final bool active;
  final void Function(int id) onChanged;
  const RadioCharacteristicWidget(
      {super.key,
      required this.value,
      required this.active,
      required this.onChanged});

  @override
  State<RadioCharacteristicWidget> createState() =>
      _RadioCharacteristicWidgetState();
}

class _RadioCharacteristicWidgetState extends State<RadioCharacteristicWidget> {
  int? id;

  final analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    getData();
    List options = widget.value['options'];

    if (options.isNotEmpty) {
      analytics.logViewItemList(
          itemListId:
              "${GAParams.radioCharacteristicsListId}_${widget.value['id']?.toString()}",
          itemListName: getTitle(),
          items: options
              .map((toElement) => AnalyticsEventItem(
                  itemName: toElement['title'],
                  itemId: toElement['id']?.toString()))
              .toList());
    }

    super.initState();
  }

  void getData() {
    if (CreateData.characteristic[widget.value['id']] != null &&
        CreateData.characteristic[widget.value['id']]) {
      id = CreateData.characteristic[widget.value['id']];
    }
    setState(() {});
  }

  String getTitle() {
    String title = widget.value['title'];
    if (widget.value['is_required']) {
      title = "$title *";
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    // List options = widget.value['options'];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(getTitle(), style: const TextStyle(fontSize: 13)),
      // const SizedBox(height: 8),
      // Column(
      //     children: options.map((value) {
      //   bool active = value['id'] == id;
      // return
      GestureDetector(
        onTap: () => widget.onChanged(widget.value['id']),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Container(
              width: 24,
              margin: const EdgeInsets.only(right: 12),
              height: 24,
              decoration: BoxDecoration(
                  color: ColorComponent.gray['50'],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: widget.active ? 5 : 1,
                      color: widget.active
                          ? ColorComponent.blue['500']!
                          : ColorComponent.gray['300']!)),
            ),
            Expanded(
                child: Text(widget.value['title'],
                    style: const TextStyle(fontWeight: FontWeight.w500)))
          ]),
        ),
      ),
      // }).toList()),
      // const Divider(height: 16)
    ]);
  }
}
