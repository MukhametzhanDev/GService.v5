import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:gservice5/pages/testCharactestic/characteristicWidgets.dart';

class TestChildCharactesticPage extends StatefulWidget {
  final List data;
  final void Function() nextPage;
  final void Function() previousPage;
  const TestChildCharactesticPage(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.data});

  @override
  State<TestChildCharactesticPage> createState() =>
      _TestChildCharactesticPageState();
}

class _TestChildCharactesticPageState extends State<TestChildCharactesticPage> {
  List data = [];
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  void verifyData() {
    for (Map value in data) {
      bool hasKey =
          CreateData.characteristic.containsKey(value['id'].toString());
      if (value['is_required'] && !hasKey) {
        SnackBarComponent()
            .showErrorMessage("Заполните строку '${value['title']}'", context);
        return;
      }
    }
    showPage();
  }

  void showPage() {
    widget.nextPage();
    pageControllerIndexedStack.nextPage();
  }

  void addData(id, value) {
    CreateData.characteristic.addAll(id);
    setState(() {});
    print(id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: CharacteristicWidget(data: data)),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: () {
                  print(CreateData.characteristic);
                  verifyData();
                },
                padding: const EdgeInsets.symmetric(horizontal: 15),
                title: "Продолжить")),
      ),
    );
  }
}
