import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/formatted/price/priceFormat.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/payment/wallet/showWalletWidget.dart';

class ViewWalletPage extends StatefulWidget {
  final String orderId;
  final int methodId;
  final Map data;
  const ViewWalletPage(
      {super.key,
      required this.orderId,
      required this.methodId,
      required this.data});

  @override
  State<ViewWalletPage> createState() => _ViewWalletPageState();
}

class _ViewWalletPageState extends State<ViewWalletPage> {
  bool bonus = false;
  int totalPrice = 0;

  @override
  void initState() {
    getTotalPrice();
    super.initState();
  }

  void getTotalPrice() {
    totalPrice = widget.data['package']['price'] +
        (widget.data['stickers'].length * 100);
    setState(() {});
  }

  int debitWallet() {
    int bonus = 1000;
    // int.parse(bonusData['amount']);
    if (totalPrice <= bonus) {
      return 0;
    } else {
      return totalPrice - bonus;
    }
  }

  int debitBonus() {
    int bonus = 2000;
    // int.parse(bonusData['amount']);
    if (totalPrice <= bonus) {
      return totalPrice;
    } else {
      return bonus;
    }
  }

  @override
  Widget build(BuildContext context) {
    List stickers = widget.data['stickers'];
    Map package = widget.data['package'];
    return Scaffold(
      appBar: AppBar(
          leading: const BackTitleButton(title: "Оплата с кошелька"),
          leadingWidth: 220),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            color: ColorComponent.gray['100'],
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: const Text("Баланс",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          const ShowWalletWidget(showButton: false),
          Container(
            color: ColorComponent.gray['100'],
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: const Text("Покупка",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: ColorComponent.gray['100']!),
                    top: BorderSide(
                        width: 1, color: ColorComponent.gray['100']!))),
            child: ListTile(
              title: Text(package['title'],
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              trailing: Text(
                "${priceFormat(package['price'])} ₸",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Column(
              children: stickers.map((value) {
            return Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: ColorComponent.gray['100']!),
                      top: BorderSide(
                          width: 1, color: ColorComponent.gray['100']!))),
              child: ListTile(
                title: Text("Стикер «${value['title']}»",
                    style:
                        const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                trailing: const Text("100 ₸",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            );
          }).toList()),
          Container(
            color: ColorComponent.gray['100'],
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: const Text("Бонус",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 2, color: ColorComponent.gray['100']!))),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 17, color: Colors.black),
                            children: <TextSpan>[
                              const TextSpan(text: "Накоплено "),
                              TextSpan(
                                  text: "${priceFormat(1000 ?? 0)} Б",
                                  style:
                                      const TextStyle(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text("Потратить бонусы",
                            style: TextStyle(
                                fontSize: 13,
                                color: ColorComponent.gray['500']))
                      ],
                    ),
                  ),
                  FlutterSwitch(
                    value: bonus,
                    width: 51,
                    height: 31,
                    borderRadius: 30,
                    activeColor: ColorComponent.mainColor,
                    inactiveColor: const Color.fromRGBO(120, 120, 128, 0.33),
                    onToggle: (value) {
                      setState(() => bonus = !bonus);
                      // changedColorStatusBar(themeChange.darkTheme);
                    },
                  ),
                ],
              )),
          AnimatedOpacity(
            opacity: bonus ? 1 : 0,
            curve: Curves.linear,
            duration: const Duration(milliseconds: 300),
            child: bonus
                ? Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Будет списано", style: TextStyle(fontSize: 17)),
                        debitWallet() == 0
                            ? Container()
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                              color:
                                                  ColorComponent.gray['100']),
                                          child: Text(
                                            "${priceFormat(debitWallet())} ₸",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text("С кошелька",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    ColorComponent.gray['500']))
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, top: 2),
                                    child: Text("+",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17)),
                                  ),
                                ],
                              ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    color: ColorComponent.blue['500']),
                                child: Text("${debitBonus()} Б",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              const SizedBox(height: 2),
                              Text("Бонусов",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: ColorComponent.gray['500']))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
          )
        ]),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: () {},
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "К оплате, ${priceFormat(totalPrice)} ₸")),
    );
  }
}
