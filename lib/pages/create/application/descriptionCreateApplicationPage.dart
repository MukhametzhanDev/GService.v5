import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class DescriptionCreateApplicationPage extends StatefulWidget {
  final void Function() nextPage;
  const DescriptionCreateApplicationPage({super.key, required this.nextPage});

  @override
  State<DescriptionCreateApplicationPage> createState() =>
      _DescriptionCreateApplicationPageState();
}

class _DescriptionCreateApplicationPageState
    extends State<DescriptionCreateApplicationPage> {
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
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
    );
  }
}
