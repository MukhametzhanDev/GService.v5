import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';

class TitleCreateAdPage extends StatefulWidget {
  final void Function() nextPage;
  final void Function() previousPage;
  final bool showTitle;
  const TitleCreateAdPage(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.showTitle});

  @override
  State<TitleCreateAdPage> createState() => _TitleCreateAdPageState();
}

class _TitleCreateAdPageState extends State<TitleCreateAdPage> {
  TextEditingController descEditingController = TextEditingController();
  TextEditingController titleEditingController = TextEditingController();
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();
  List tags = [];
  bool loader = true;

  final analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    descEditingController.dispose();
    titleEditingController.dispose();
    super.dispose();
  }

  Future getData() async {
    int categoryId = CreateData.data['category_id'];
    print("CATEGORYID $categoryId");
    try {
      Response response = await dio.get("/description-tags",
          queryParameters: {"category_id": categoryId});
      if (response.data['success']) {
        tags = response.data['data'];

        loader = false;
        setState(() {});

        await analytics.logViewItemList(
            itemListId: GAParams.descriptionTagsListId,
            itemListName: GAParams.descriptionTagsListName,
            items: tags
                .map((e) => AnalyticsEventItem(
                    itemName: e['title'] ?? '', itemId: e['id']?.toString()))
                .toList());
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {}
  }

  void verifyData() {
    String desc = descEditingController.text.trim();
    if (widget.showTitle && titleEditingController.text.isEmpty) {
      SnackBarComponent().showErrorMessage("Введите заголовок", context);
    } else if (desc.isEmpty) {
      SnackBarComponent().showErrorMessage("Введите описание", context);
    } else {
      savedData();
    }
  }

  void changeTag(value) {
    print('object');
    String title = value['title'] + ". ";
    if (value?['active'] ?? false) {
      value['active'] = false;
      descEditingController.text =
          descEditingController.text.replaceAll(RegExp(title), "");
    } else {
      descEditingController.text += title;
      value['active'] = true;
    }
    setState(() {});
  }

  void savedData() {
    CreateData.data['description'] = descEditingController.text;
    String title = titleEditingController.text.trim();
    if (title.isNotEmpty) {
      CreateData.data['title'] = titleEditingController.text;
    }
    pageControllerIndexedStack.nextPage();
    widget.nextPage();

    var selectedTags = tags.where((e) => e?['active'] == true).toList();

    analytics
        .logSelectItem(
            itemListId: GAParams.descriptionTagsListId,
            itemListName: GAParams.descriptionTagsListName,
            items: selectedTags
                .map((e) => AnalyticsEventItem(
                    itemName: e['title'] ?? '', itemId: e['id'].toString()))
                .toList())
        .catchError((e) {
      if (kDebugMode) {
        debugPrint(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text("Напишите подробности",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
          widget.showTitle
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                      controller: titleEditingController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          hintText: "Введите заголовок",
                          helperStyle:
                              TextStyle(color: ColorComponent.gray['500']))),
                )
              : Container(),
          TextField(
              controller: descEditingController,
              style: const TextStyle(fontSize: 14),
              maxLength: 1000,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 14,
              minLines: 6,
              decoration: InputDecoration(
                  hintText: "Что нужно сделать?",
                  helperStyle: TextStyle(color: ColorComponent.gray['500']))),
          Text("Например: Нужен трактор для участка",
              style: TextStyle(color: ColorComponent.gray['500'])),
          const Divider(height: 24),
          loader
              ? Container()
              : Wrap(
                  children: tags.map((value) {
                  return GestureDetector(
                    onTap: () {
                      changeTag(value);
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        margin: const EdgeInsets.only(bottom: 15, right: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: value['active'] ?? false
                                ? ColorComponent.mainColor
                                : ColorComponent.gray['100']),
                        child: Text(value['title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                  );
                }).toList()),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyData,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Продолжить")),
    );
  }
}
