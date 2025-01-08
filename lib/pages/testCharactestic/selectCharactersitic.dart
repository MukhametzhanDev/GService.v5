import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/ad/characteristic/modalButtonComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SelectCharactersitic extends StatefulWidget {
  final Map value;
  const SelectCharactersitic({super.key, required this.value});

  @override
  State<SelectCharactersitic> createState() => _SelectCharactersiticState();
}

class _SelectCharactersiticState extends State<SelectCharactersitic> {
  Map currentValue = {};

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {}

  String getInitialValue() {
    if (CreateData.characteristic[widget.value['id']] == null) {
      return "";
    } else {
      return CreateData.characteristic[widget.value['id']].toString();
    }
  }

  String getTitle() {
    String title = widget.value['title'];
    if (widget.value['is_required']) {
      title = "$title *";
    }
    return title;
  }

  void showModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => SelectModal(
              data: widget.value['options'],
              value: currentValue,
              listTitle: getTitle(),
              listId: widget.value['id']?.toString(),
            )).then(onChanged);
  }

  void onChanged(value) {
    if (value != null) {
      CreateData.characteristic["${widget.value['id']}"] = value['id'];
      currentValue = value;
      setState(() {});

      GetIt.I<FirebaseAnalytics>().logSelectItem(
          itemListId:
              "${GAParams.selectCharacteristicsListEd}_${widget.value['id'].toString()}",
          itemListName: getTitle(),
          items: [
            AnalyticsEventItem(
                itemName: value?['title'], itemId: value?['id'].toString())
          ]).catchError((onError) => debugPrint(onError));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(, style: const TextStyle(fontSize: 13)),
      // const SizedBox(height: 7),
      ModalButtonComponent(
          padding: false,
          onPressed: showModal,
          title: getTitle(),
          subtitle: currentValue),
      const SizedBox(height: 16),
    ]);
  }
}

class SelectModal extends StatefulWidget {
  final List data;
  final Map value;
  final String? listTitle;
  final String? listId;

  const SelectModal(
      {super.key,
      required this.data,
      required this.value,
      this.listTitle,
      this.listId});

  @override
  State<SelectModal> createState() => _SelectModalState();
}

class _SelectModalState extends State<SelectModal> {
  void onChanged(value) {
    Navigator.pop(context, value);
  }

  @override
  void initState() {
    GetIt.I<FirebaseAnalytics>()
        .logViewItemList(
            itemListId:
                '${GAParams.selectCharacteristicsListEd}_${widget.listId}',
            itemListName: widget.listTitle ?? '',
            items: widget.data
                .map((toElement) => AnalyticsEventItem(
                    itemName: toElement?['title'],
                    itemId: toElement?['id'].toString()))
                .toList())
        .catchError((onError) => debugPrint(onError));

    super.initState();
  }

  bool checkActive(value) {
    if (widget.value.isEmpty) {
      return false;
    } else {
      if (widget.value['id'] == value['id']) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
            actions: const [CloseIconButton(iconColor: null, padding: true)],
            automaticallyImplyLeading: false,
            title: const Text("Выберите")),
        body: ListView.builder(
          itemCount: widget.data.length,
          physics: physics,
          itemBuilder: (context, index) {
            Map value = widget.data[index];
            bool active = checkActive(value);
            return GestureDetector(
              onTap: () => onChanged(value),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: ColorComponent.gray['100']!))),
                child: ListTile(
                    title: Text(value['title'],
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    trailing: active
                        ? SvgPicture.asset("assets/icons/check.svg",
                            width: 20, color: ColorComponent.blue['500'])
                        : const SizedBox.shrink()),
              ),
            );
          },
        ),
      );
    });
  }
}
