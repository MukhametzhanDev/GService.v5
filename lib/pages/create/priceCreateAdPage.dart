import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/functions/number/getIntNumber.dart';
import 'package:gservice5/component/message/explanatoryMessage.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:gservice5/pages/profile/currency/currencyButton.dart';
import 'package:intl/intl.dart';

class PriceCreateAdPage extends StatefulWidget {
  final void Function() nextPage;
  final void Function() previousPage;
  final List data;
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
  TextEditingController perShiftEditingController = TextEditingController();
  TextEditingController perHourEditingController = TextEditingController();
  bool negotiablePrice = false;
  CurrencyTextInputFormatter currencyTextInputFormatter =
      CurrencyTextInputFormatter(
          NumberFormat.currency(decimalDigits: 0, symbol: "", locale: 'kk'));
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  final analytics = FirebaseAnalytics.instance;

  @override
  void dispose() {
    priceEditingController.dispose();
    perShiftEditingController.dispose();
    perHourEditingController.dispose();
    super.dispose();
  }

  void savedData() {
    Map createData = {};
    if (!negotiablePrice) {
      if (perShiftEditingController.text.isNotEmpty) {
        createData['price_per_shift'] =
            getIntComponent(perShiftEditingController.text);
      }
      if (perHourEditingController.text.isNotEmpty) {
        createData['price_per_hour'] =
            getIntComponent(perHourEditingController.text);
      }
      if (priceEditingController.text.isNotEmpty) {
        createData['price'] = getIntComponent(priceEditingController.text);
      }

      CreateData.data.addAll({"price": createData});
    }
  }

  void showPage() {
    savedData();
    widget.nextPage();
    pageControllerIndexedStack.nextPage();

    analytics.logEvent(name: GAEventName.buttonClick, parameters: {
      GAKey.buttonName: GAParams.btnPriceContinue,
      GAKey.screenName: GAParams.priceCreateAdPage
    }).catchError((e) {
      if (kDebugMode) {
        debugPrint(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text("Цена",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
          const ExplanatoryMessage(
              title:
                  "Цену лучше указать — так удобнее для покупателей. Если цена не указана, то при расширенном поиске покупатели могут не найти ваше объявление, а в объявлении будет автоматически указана стоимость «По запросу».",
              padding: EdgeInsets.only(bottom: 15),
              type: "application-price"),
          // Text("Укажите цену",
          //     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          // Divider(),
          Column(
              children: widget.data.map((value) {
            return Column(children: [
              value == 'price'
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onSubmitted: (value) {},
                              enabled: !negotiablePrice,
                              inputFormatters: [currencyTextInputFormatter],
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 14, height: 1.1),
                              controller: priceEditingController,
                              decoration: InputDecoration(
                                  hintText: negotiablePrice
                                      ? 'Договорная'
                                      : 'Введите цену'),
                            ),
                          ),
                          const CurrencyButton()
                        ],
                      ),
                    )
                  : Container(),
              value == 'price_per_shift'
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        onSubmitted: (value) {},
                        enabled: !negotiablePrice,
                        inputFormatters: [currencyTextInputFormatter],
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 14, height: 1.1),
                        controller: perShiftEditingController,
                        decoration: InputDecoration(
                            hintText: negotiablePrice
                                ? 'Договорная'
                                : 'Цена за смену'),
                      ),
                    )
                  : Container(),
              value == 'price_per_hour'
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        onSubmitted: (value) {},
                        enabled: !negotiablePrice,
                        inputFormatters: [currencyTextInputFormatter],
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 14, height: 1.1),
                        controller: perHourEditingController,
                        decoration: InputDecoration(
                            hintText:
                                negotiablePrice ? 'Договорная' : 'Цена за час'),
                      ),
                    )
                  : Container(),
              value == 'negotiable'
                  ? ListTile(
                      onTap: () {
                        negotiablePrice = !negotiablePrice;
                        setState(() {});
                        closeKeyboard();

                        analytics.logEvent(
                            name: GAEventName.buttonClick,
                            parameters: {
                              'button_name': GAParams.chkNegotiable
                            }).catchError((e) {
                          if (kDebugMode) {
                            debugPrint(e);
                          }
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: negotiablePrice
                                ? const Color(0xff1A56DB)
                                : null,
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
                    )
                  : Container(),
            ]);
          }).toList()),
          Text("Если поле цены не заполнено, цена будет указано как договорная",
              style: TextStyle(color: ColorComponent.gray['500']))
        ]),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: showPage,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Продолжить")),
    );
  }
}
