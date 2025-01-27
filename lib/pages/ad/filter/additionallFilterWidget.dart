import 'package:flutter/material.dart';
import 'package:gservice5/component/button/radio/radioButton.dart';
import 'package:gservice5/component/widgets/checkBox/checkBoxWidget.dart';
import 'package:gservice5/provider/adFilterProvider.dart';
import 'package:provider/provider.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class AdditionallFilterWidget extends StatefulWidget {
  final int categoryId;
  final Map data;
  const AdditionallFilterWidget(
      {super.key, required this.categoryId, required this.data});

  @override
  State<AdditionallFilterWidget> createState() =>
      _AdditionallFilterWidgetState();
}

class _AdditionallFilterWidgetState extends State<AdditionallFilterWidget> {
  // 278 = state new
  // 279 = state used

  void changedWithImage(bool value) {
    Provider.of<AdFilterProvider>(context, listen: false).filterData = {
      "with_image": !value
    };
  }

  void onChangedState(int id) {
    Provider.of<AdFilterProvider>(context, listen: false).filterData = {
      "state": id
    };
  }

  Widget StateWidget(data) {
    if (widget.categoryId == 1 || widget.categoryId == 4) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 24),
          Text(context.localizations.condition),
          const Divider(height: 8),
          Row(children: [
            RadioButtonWidget(
                active: data['state'] == 278,
                title: context.localizations.new_title,
                onChanged: (value) => onChangedState(278)),
            const Divider(indent: 24),
            RadioButtonWidget(
                active: data['state'] == 279,
                title: context.localizations.used,
                onChanged: (value) => onChangedState(279))
          ]),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget AdditionalFilterWidget(data) {
    if (widget.categoryId == 1 ||
        widget.categoryId == 2 ||
        widget.categoryId == 4) {
      bool active = data['with_image'] ?? false;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 24),
          GestureDetector(
            onTap: () => changedWithImage(active),
            child: Row(
              children: [
                CheckBoxWidget(active: active),
                const Divider(indent: 12),
                const Expanded(
                    child: Text("С фото", style: TextStyle(fontSize: 15)))
              ],
            ),
          ),
          const Divider(height: 24),
          const Row(
            children: [
              CheckBoxWidget(active: false),
              Divider(indent: 12),
              Expanded(child: Text("Официальный диллер"))
            ],
          )
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StateWidget(widget.data),
      AdditionalFilterWidget(widget.data)
    ]);
  }
}
