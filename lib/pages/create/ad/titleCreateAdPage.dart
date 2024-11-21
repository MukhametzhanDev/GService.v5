import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class TitleCreateAdPage extends StatefulWidget {
  final void Function() nextPage;
  const TitleCreateAdPage({super.key, required this.nextPage});

  @override
  State<TitleCreateAdPage> createState() => _TitleCreateAdPageState();
}

class _TitleCreateAdPageState extends State<TitleCreateAdPage> {
  TextEditingController descEditingController = TextEditingController();

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
    widget.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(
            leadingWidth: MediaQuery.of(context).size.width - 100,
            leading: BackTitleButton(
                title: "Описание", onPressed: () => Navigator.pop(context))),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Напишите подробности",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
            Divider(height: 8),
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
      ),
    );
  }
}
