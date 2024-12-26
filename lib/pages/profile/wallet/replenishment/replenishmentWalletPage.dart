import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/profile/wallet/replenishment/successfulPaymentPage.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ReplenishmentWalletPage extends StatefulWidget {
  const ReplenishmentWalletPage({super.key});

  @override
  State<ReplenishmentWalletPage> createState() =>
      _ReplenishmentWalletPageState();
}

class _ReplenishmentWalletPageState extends State<ReplenishmentWalletPage> {
  List prices = [2000, 5000, 15000, 50000];
  TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  int percentagePrice() {
    int price = 0;
    int priceNew = getIntComponent(priceController.text);
    if (priceNew > 50000) {
      price = (priceNew * 0.2).round();
    } else {
      price = (priceNew * 0.1).round();
    }
    setState(() {});
    return price;
  }

  void verifyData() {
    String price = priceController.text.trim();
    if (price.isEmpty) {
      SnackBarComponent().showErrorMessage("Заполните все строки", context);
    } else {
      showModal();
    }
  }

  void showModal() {
    showMaterialModalBottomSheet(
        context: context, builder: (context) => const SuccessfulPaymentPage());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(),
      child: Scaffold(
        appBar: AppBar(
            leadingWidth: 300,
            leading: const BackTitleButton(title: "Пополнение баланса"),
            centerTitle: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Введите сумму пополнения",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Divider(indent: 16),
            Row(
                children: prices.map((value) {
              return GestureDetector(
                onTap: () {
                  priceController.text = priceFormat(value);
                  percentagePrice();
                },
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: ColorComponent.mainColor),
                        borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.only(right: 8),
                    child: Text("${priceFormat(value)} ₸",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600))),
              );
            }).toList()),
            const Divider(indent: 16),
            TextFormField(
                controller: priceController,
                maxLength: 13,
                autofocus: true,
                onChanged: (value) {
                  percentagePrice();
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 18, right: 10, top: 10, bottom: 10),
                    suffix: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                              color: ColorComponent.mainColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                              "+ ${NumberFormat.currency(locale: 'kk', symbol: '').format(percentagePrice()).toString().split(',')[0]} бонус",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black))),
                    ),
                    hintText: "Введите цену",
                    counterText: "",
                    helperStyle: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.black),
                inputFormatters: [
                  CurrencyTextInputFormatter.currency(
                      decimalDigits: 0, locale: 'kk', symbol: "₸")
                ]),
            const Divider(indent: 15),
            RichText(
                text: TextSpan(
                    style: TextStyle(color: ColorComponent.gray['500']),
                    children: const [
                  TextSpan(text: "От 50 000 ₸ "),
                  TextSpan(
                      text: "+20% бонус",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ])),
          ]),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Button(
                onPressed: verifyData,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                title: "Пополнить баланс")),
      ),
    );
  }
}
