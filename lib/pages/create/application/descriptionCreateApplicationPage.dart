import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class DescriptionCreateApplicationPage extends StatefulWidget {
  final void Function() previousPage;
  final void Function() nextPage;
  final String exampleTitle;
  DescriptionCreateApplicationPage(
      {super.key,
      required this.previousPage,
      required this.nextPage,
      required this.exampleTitle});
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  @override
  State<DescriptionCreateApplicationPage> createState() =>
      _DescriptionCreateApplicationPageState();
}

class _DescriptionCreateApplicationPageState
    extends State<DescriptionCreateApplicationPage> {
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
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(context.localizations.description,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          const Divider(height: 8),
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
          Text(widget.exampleTitle,
              style: TextStyle(color: ColorComponent.gray['500']))
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
