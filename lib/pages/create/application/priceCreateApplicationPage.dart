import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/message/explanatoryMessage.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/priceTextField.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class PriceCreateApplicationPage extends StatefulWidget {
  final void Function() nextPage;
  const PriceCreateApplicationPage({super.key, required this.nextPage});

  @override
  State<PriceCreateApplicationPage> createState() =>
      _PriceCreateApplicationPageState();
}

class _PriceCreateApplicationPageState
    extends State<PriceCreateApplicationPage> {
  List data = [
    {'title': "Фиксированная"},
    {'title': "Вариативная"},
    {'title': "Договорная"},
  ];
  int currentIndex = 0;
  TextEditingController fromPriceEditingController = TextEditingController();
  TextEditingController toPriceEditingController = TextEditingController();

  void verifyData() {
    String fromPrice = fromPriceEditingController.text.trim();
    String toPrice = toPriceEditingController.text.trim();
    if (currentIndex == 0) {
      if (fromPrice.isEmpty) {
        SnackBarComponent().showErrorMessage("Заполните все строки", context);
      } else {
        showPage();
      }
    } else if (currentIndex == 1) {
      if (fromPrice.isEmpty || toPrice.isEmpty) {
        SnackBarComponent().showErrorMessage("Заполните все строки", context);
      } else {
        int from = getIntComponent(fromPrice);
        int to = getIntComponent(toPrice);
        if (from < to) {
          showPage();
        } else {
          SnackBarComponent().showErrorMessage("", context);
        }
      }
    } else {
      showPage();
    }
  }

  @override
  void dispose() {
    fromPriceEditingController.dispose();
    toPriceEditingController.dispose();
    super.dispose();
  }

  void savedData() {
    Map createData = CreateData.data;
    if (currentIndex == 0) {
      createData['price'] = getIntComponent(fromPriceEditingController.text);
      createData.remove("price_from");
      createData.remove("price_to");
    } else if (currentIndex == 1) {
      createData.remove("price");
      createData["price_from"] =
          getIntComponent(fromPriceEditingController.text);
      CreateData.data["price_to"] =
          getIntComponent(toPriceEditingController.text);
    } else {
      createData.remove("price_from");
      createData.remove("price_to");
      createData.remove("price");
    }
  }

  void showPage() {
    savedData();
    widget.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          ExplanatoryMessage(
              title:
                  "Цену лучше указать — так удобнее для покупателей. Если цена не указана, то при расширенном поиске покупатели могут не найти ваше объявление, а в объявлении будет автоматически указана стоимость «По запросу».",
              padding: EdgeInsets.zero,
              type: "application-price1"),
          Divider(height: 10),
          Column(
              children: data.map((value) {
            int index = data.indexOf(value);
            bool active = index == currentIndex;
            return SizedBox(
              height: 46,
              child: ListTile(
                onTap: () {
                  currentIndex = index;
                  setState(() {});
                },
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: active ? Color(0xff1A56DB) : null,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          width: 1,
                          color:
                              active ? Color(0xff1A56DB) : Color(0xffD1D5DB))),
                  child: active
                      ? SvgPicture.asset('assets/icons/checkMini.svg',
                          color: Colors.white)
                      : Container(),
                ),
                title: Text(value['title']),
              ),
            );
          }).toList()),
          Divider(),
          currentIndex == 0
              ? PriceTextField(
                  textEditingController: fromPriceEditingController,
                  autofocus: false,
                  title: "Цена",
                  onSubmitted: savedData)
              : currentIndex == 1
                  ? Row(children: [
                      Expanded(
                        child: PriceTextField(
                            textEditingController: fromPriceEditingController,
                            autofocus: false,
                            title: "От",
                            onSubmitted: () {}),
                      ),
                      Divider(indent: 12),
                      Expanded(
                        child: PriceTextField(
                            textEditingController: toPriceEditingController,
                            autofocus: false,
                            title: "До",
                            onSubmitted: savedData),
                      )
                    ])
                  : Container()
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
