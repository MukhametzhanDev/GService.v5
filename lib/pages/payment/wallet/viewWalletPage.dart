import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/payment/wallet/showWalletWidget.dart';
import 'package:gservice5/provider/walletAmountProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewWalletPage extends StatefulWidget {
  final String orderId;
  final String title;
  final int methodId;
  final Map data;
  const ViewWalletPage(
      {super.key,
      required this.orderId,
      required this.title,
      required this.methodId,
      required this.data});

  @override
  State<ViewWalletPage> createState() => _ViewWalletPageState();
}

class _ViewWalletPageState extends State<ViewWalletPage> {
  bool bonus = false;
  int totalPrice = 0;

  final analytics = GetIt.I<FirebaseAnalytics>();

  @override
  void initState() {
    getTotalPrice();
    super.initState();
  }

  Future postData() async {
    showModalLoader(context);
    try {
      Response response = await dio.post("/make-payment", data: {
        "order_id": widget.orderId,
        "payment_method_id": widget.methodId,
        "with_bonus": bonus
      });
      // await WalletAmountProvider().getData(context);
      Navigator.pop(context);
      if (response.data['success'] && response.statusCode == 200) {
        Navigator.pop(context, "success");

        await analytics.logEvent(name: GAEventName.tolem, parameters: {
          'price': totalPrice.toString(),
          'status': "success",
          'type': "package",
        });
      } else {
        Navigator.pop(context);
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void getTotalPrice() {
    totalPrice = widget.data['package']['price'] +
        (widget.data['stickers'].length * 100);
    setState(() {});
  }

  int debitWallet(int bonus) {
    // int.parse(bonusData['amount']);
    if (totalPrice <= bonus) {
      return 0;
    } else {
      return totalPrice - bonus;
    }
  }

  int debitBonus(int bonus) {
    // int.parse(bonusData['amount']);
    if (totalPrice <= bonus) {
      return totalPrice;
    } else {
      return bonus;
    }
  }

  String formattedPrice(int cost) {
    String price = NumberFormat.currency(locale: 'kk', symbol: '')
        .format(cost)
        .toString()
        .split(',')[0];
    return price;
  }

  @override
  Widget build(BuildContext context) {
    List stickers = widget.data['stickers'];
    Map package = widget.data['package'];
    // final walletAmount = Provider.of<WalletAmountProvider>(context);

    return Scaffold(
      appBar: AppBar(
          leading: BackTitleButton(title: widget.title), leadingWidth: 220),
      body: Consumer<WalletAmountProvider>(builder: (context, data, child) {
        return data.loading
            ? LoaderComponent()
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: ColorComponent.gray['100'],
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: const Text("Баланс",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                      const ShowWalletWidget(
                        showButton: false,
                        fromPage: GAParams.viewWalletPage,
                      ),
                      Container(
                        color: ColorComponent.gray['100'],
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: const Text("Покупка",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: ColorComponent.gray['100']!),
                                top: BorderSide(
                                    width: 1,
                                    color: ColorComponent.gray['100']!))),
                        child: ListTile(
                          title: Text(package['title'],
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400)),
                          trailing: Text(
                            "${formattedPrice(package['price'])} ₸",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Column(
                          children: stickers.map((value) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: ColorComponent.gray['100']!),
                                  top: BorderSide(
                                      width: 1,
                                      color: ColorComponent.gray['100']!))),
                          child: ListTile(
                            title: Text("Стикер «${value['title']}»",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400)),
                            trailing: const Text("100 ₸",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        );
                      }).toList()),
                      Container(
                        color: ColorComponent.gray['100'],
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: const Text("Бонус",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                      Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 2,
                                      color: ColorComponent.gray['100']!))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                            fontSize: 17, color: Colors.black),
                                        children: <TextSpan>[
                                          const TextSpan(text: "Накоплено "),
                                          TextSpan(
                                              text:
                                                  "${formattedPrice(data.data.bonus ?? 0)} Б",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700)),
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
                                inactiveColor:
                                    const Color.fromRGBO(120, 120, 128, 0.33),
                                onToggle: (value) {
                                  setState(() => bonus = !bonus);
                                  analytics.logEvent(
                                      name: GAEventName.buttonClick,
                                      parameters: {
                                        GAKey.buttonName:
                                            GAParams.btnSwitchBonus
                                      }).catchError((e) {
                                    if (kDebugMode) {
                                      debugPrint(e);
                                    }
                                  });
                                  // changedColorStatusBar(themeChange.darkTheme);
                                },
                              ),
                            ],
                          )),
                      AnimatedOpacity(
                        opacity: bonus ? 1 : 0,
                        curve: Curves.linear,
                        duration: const Duration(milliseconds: 200),
                        child: bonus
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Будет списано",
                                        style: TextStyle(fontSize: 15)),
                                    debitWallet(data.data.bonus ?? 0) == 0
                                        ? Container()
                                        : Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4,
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(13),
                                                          color: ColorComponent
                                                              .gray['100']),
                                                      child: Text(
                                                        "${formattedPrice(debitWallet(data.data.bonus ?? 0))} ₸",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text("С кошелька",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                ColorComponent
                                                                        .gray[
                                                                    '500']))
                                                  ],
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15, top: 2),
                                                child: Text("+",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 17)),
                                              ),
                                            ],
                                          ),
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
                                                    ColorComponent.blue['500']),
                                            child: Text(
                                                "${debitBonus(data.data.bonus ?? 0)} Б",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          const SizedBox(height: 2),
                                          Text("Бонусов",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: ColorComponent
                                                      .gray['500']))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      )
                    ]),
              );
      }),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Button(
              onPressed: () {
                postData();
              },
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "К оплате, ${formattedPrice(totalPrice)} ₸")),
    );
  }
}
