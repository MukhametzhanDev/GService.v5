import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  const TitleCreateAdPage(
      {super.key, required this.nextPage, required this.previousPage});

  @override
  State<TitleCreateAdPage> createState() => _TitleCreateAdPageState();
}

class _TitleCreateAdPageState extends State<TitleCreateAdPage> {
  TextEditingController descEditingController = TextEditingController();
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();
  List tags = [];
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    descEditingController.dispose();
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
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {}
  }

  void verifyData() {
    String desc = descEditingController.text.trim();
    if (desc.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
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
    pageControllerIndexedStack.nextPage();
    widget.nextPage();
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
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 8, top: 8),
                        margin: const EdgeInsets.only(bottom: 12, right: 12),
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
