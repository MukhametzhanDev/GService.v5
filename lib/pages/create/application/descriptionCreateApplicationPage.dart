import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';

class DescriptionCreateApplicationPage extends StatefulWidget {
  final void Function() nextPage;
  const DescriptionCreateApplicationPage({super.key, required this.nextPage});

  @override
  State<DescriptionCreateApplicationPage> createState() =>
      _DescriptionCreateApplicationPageState();
}

class _DescriptionCreateApplicationPageState
    extends State<DescriptionCreateApplicationPage> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descEditingController = TextEditingController();

  void verifyData() {
    String title = titleEditingController.text.trim();
    String desc = descEditingController.text.trim();
    if (title.isEmpty || desc.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      widget.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Заголовок", style: TextStyle(fontWeight: FontWeight.w600)),
          Divider(height: 6),
          TextField(
              controller: titleEditingController,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(hintText: "Введите заголовок")),
          Divider(),
          Text("Описание", style: TextStyle(fontWeight: FontWeight.w600)),
          Divider(height: 6),
          TextField(
              controller: descEditingController,
              style: TextStyle(fontSize: 14),
              maxLength: 1000,
              maxLines: 14,
              minLines: 6,
              decoration: InputDecoration(
                  hintText: "Введите описание",
                  helperStyle: TextStyle(color: ColorComponent.gray['500'])))
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
