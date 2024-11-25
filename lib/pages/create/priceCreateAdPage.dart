import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/message/explanatoryMessage.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:intl/intl.dart';

class PriceCreateAdPage extends StatefulWidget {
  final void Function() nextPage;
  final void Function() previousPage;
  final Map data;
  const PriceCreateAdPage(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.data});

  @override
  State<PriceCreateAdPage> createState() => _PriceCreateAdPageState();
}

class _PriceCreateAdPageState extends State<PriceCreateAdPage> {
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController formPriceEditingController = TextEditingController();
  TextEditingController toPriceEditingController = TextEditingController();
  bool negotiablePrice = false;
  CurrencyTextInputFormatter currencyTextInputFormatter =
      CurrencyTextInputFormatter(
          NumberFormat.currency(decimalDigits: 0, symbol: "", locale: 'kk'));
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  void verifyData() {
    String price = priceEditingController.text.trim();
    String priceFrom = formPriceEditingController.text.trim();
    String priceTo = toPriceEditingController.text.trim();
    if (!negotiablePrice) {
      if (widget.data['price_per_shift'] && widget.data['price_per_hour']) {
        if (priceFrom.isNotEmpty || priceTo.isNotEmpty) {
          showPage();
        } else {
          SnackBarComponent().showErrorMessage("Заполните все строки", context);
        }
      } else {
        if (price.isEmpty) {
          SnackBarComponent().showErrorMessage("Заполните все строки", context);
        } else {
          showPage();
        }
      }
    } else {
      showPage();
    }
  }

  @override
  void initState() {
    print(widget.data);
    super.initState();
  }

  @override
  void dispose() {
    priceEditingController.dispose();
    formPriceEditingController.dispose();
    toPriceEditingController.dispose();
    super.dispose();
  }

  void savedData() {
    CreateData.data.addAll({"price": {}});
    Map createData = CreateData.data['price'];
    if (widget.data['price_per_shift'] && widget.data['price_per_hour']) {
      if (!negotiablePrice) {
        createData['price_per_shift'] =
            getIntComponent(formPriceEditingController.text);
        createData['price_per_hour'] =
            getIntComponent(toPriceEditingController.text);
      } else {
        createData.remove("price_per_shift");
        createData.remove("price_per_hour");
      }
    } else {
      if (!negotiablePrice) {
        createData['price'] = getIntComponent(priceEditingController.text);
      } else {
        createData.remove("price");
      }
    }
  }

  void showPage() {
    savedData();
    widget.nextPage();
    pageControllerIndexedStack.nextPage();
    print(CreateData.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ExplanatoryMessage(
              title:
                  "Цену лучше указать — так удобнее для покупателей. Если цена не указана, то при расширенном поиске покупатели могут не найти ваше объявление, а в объявлении будет автоматически указана стоимость «По запросу».",
              padding: EdgeInsets.only(bottom: 15),
              type: "application-price1"),
          Text("Укажите цену",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          Divider(),
          SizedBox(
            height: 48,
            child: widget.data['price_per_shift'] &&
                    widget.data['price_per_hour']
                ? Row(children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          verifyData();
                        },
                        enabled: !negotiablePrice,
                        inputFormatters: [currencyTextInputFormatter],
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14, height: 1.1),
                        controller: formPriceEditingController,
                        decoration: InputDecoration(
                            hintText: negotiablePrice
                                ? 'Договорная'
                                : 'Цена за смену'),
                      ),
                    ),
                    Divider(indent: 12),
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          verifyData();
                        },
                        enabled: !negotiablePrice,
                        inputFormatters: [currencyTextInputFormatter],
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14, height: 1.1),
                        controller: toPriceEditingController,
                        decoration: InputDecoration(
                            hintText:
                                negotiablePrice ? 'Договорная' : 'Цена за час'),
                      ),
                    ),
                  ])
                : TextField(
                    onSubmitted: (value) {
                      verifyData();
                    },
                    enabled: !negotiablePrice,
                    inputFormatters: [currencyTextInputFormatter],
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 14, height: 1.1),
                    controller: priceEditingController,
                    decoration: InputDecoration(
                        hintText:
                            negotiablePrice ? 'Договорная' : 'Введите цену'),
                  ),
          ),
          ListTile(
            onTap: () {
              negotiablePrice = !negotiablePrice;
              setState(() {});
              closeKeyboard();
            },
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: negotiablePrice ? Color(0xff1A56DB) : null,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      width: 1,
                      color: negotiablePrice
                          ? Color(0xff1A56DB)
                          : Color(0xffD1D5DB))),
              child: negotiablePrice
                  ? SvgPicture.asset('assets/icons/checkMini.svg',
                      color: Colors.white)
                  : Container(),
            ),
            title: Text("Договорная"),
          ),
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
