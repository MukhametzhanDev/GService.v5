import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/message/explanatoryMessage.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:intl/intl.dart';

class PriceCreateApplicationPage extends StatefulWidget {
  final void Function() nextPage;
  final bool canLease;
  const PriceCreateApplicationPage(
      {super.key, required this.nextPage, required this.canLease});

  @override
  State<PriceCreateApplicationPage> createState() =>
      _PriceCreateApplicationPageState();
}

class _PriceCreateApplicationPageState
    extends State<PriceCreateApplicationPage> {
  TextEditingController priceEditingController = TextEditingController();
  bool negotiablePrice = false;
  bool canLease = false;
  CurrencyTextInputFormatter currencyTextInputFormatter =
      CurrencyTextInputFormatter(
          NumberFormat.currency(decimalDigits: 0, symbol: "", locale: 'kk'));
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  void verifyData() {
    String fromPrice = priceEditingController.text.trim();
    if (!negotiablePrice) {
      if (fromPrice.isEmpty) {
        SnackBarComponent().showErrorMessage("Заполните все строки", context);
      } else {
        showPage();
      }
    } else {
      showPage();
    }
  }

  @override
  void dispose() {
    priceEditingController.dispose();
    super.dispose();
  }

  void savedData() {
    if (!negotiablePrice) {
      CreateData.data['price'] = {
        "price": getIntComponent(priceEditingController.text)
      };
    } else {
      CreateData.data.remove("price");
    }
    CreateData.data.addAll({"can_lease": canLease});
  }

  void showPage() {
    savedData();
    pageControllerIndexedStack.nextPage();
    widget.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const ExplanatoryMessage(
              title:
                  "Цену лучше указать — так удобнее для покупателей. Если цена не указана, то при расширенном поиске покупатели могут не найти ваше объявление, а в объявлении будет автоматически указана стоимость «По запросу».",
              padding: EdgeInsets.only(bottom: 15),
              type: "application-price"),
          const Text("Укажите цену",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          const Divider(),
          SizedBox(
            height: 48,
            child: TextField(
              onSubmitted: (value) {
                verifyData();
              },
              enabled: !negotiablePrice,
              inputFormatters: [currencyTextInputFormatter],
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14, height: 1.1),
              controller: priceEditingController,
              decoration: InputDecoration(
                  hintText: negotiablePrice ? 'Договорная' : 'Введите цену'),
            ),
          ),
          ListTile(
            onTap: () {
              negotiablePrice = !negotiablePrice;
              setState(() {});
            },
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: negotiablePrice ? const Color(0xff1A56DB) : null,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      width: 1,
                      color: negotiablePrice
                          ? const Color(0xff1A56DB)
                          : const Color(0xffD1D5DB))),
              child: negotiablePrice
                  ? SvgPicture.asset('assets/icons/checkMini.svg',
                      color: Colors.white)
                  : Container(),
            ),
            title: const Text("Договорная"),
          ),
          widget.canLease
              ? ListTile(
                  onTap: () {
                    canLease = !canLease;
                    setState(() {});
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: canLease ? const Color(0xff1A56DB) : null,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            width: 1,
                            color: canLease
                                ? const Color(0xff1A56DB)
                                : const Color(0xffD1D5DB))),
                    child: canLease
                        ? SvgPicture.asset('assets/icons/checkMini.svg',
                            color: Colors.white)
                        : Container(),
                  ),
                  title: const Text("Лизинг"),
                )
              : Container(),
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
