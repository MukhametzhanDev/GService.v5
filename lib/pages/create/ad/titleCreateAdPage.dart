import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
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

  @override
  void dispose() {
    descEditingController.dispose();
    super.dispose();
  }

  void verifyData() {
    String desc = descEditingController.text.trim();
    if (desc.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      savedData();
    }
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
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Text("Напишите подробности",
          //     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 2
          // 0)),
          Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text("Напишите подробности",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
          // Divider(height: 8),
          TextField(
              controller: descEditingController,
              style: TextStyle(fontSize: 14),
              maxLength: 1000,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 14,
              minLines: 6,
              decoration: InputDecoration(
                  hintText: "Что нужно сделать?",
                  helperStyle: TextStyle(color: ColorComponent.gray['500']))),
          Text(
            "Например: Нужен трактор для участка",
            style: TextStyle(color: ColorComponent.gray['500']),
          )
        ]),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: verifyData,
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: "Продолжить")),
    );
  }
}
