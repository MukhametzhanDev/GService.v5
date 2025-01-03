import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/payment/viewPaymentPage.dart';
import 'package:gservice5/pages/payment/wallet/viewWalletPage.dart';

class PaymentMethodModal extends StatefulWidget {
  final String orderId;
  final Map data;
  const PaymentMethodModal(
      {super.key, required this.orderId, required this.data});

  @override
  State<PaymentMethodModal> createState() => _PaymentMethodModalState();
}

class _PaymentMethodModalState extends State<PaymentMethodModal> {
  List data = [];
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    try {
      Response response = await dio.get("/payment-methods");
      if (response.data['success'] && response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void showPaymentPage(Map value) {
    if (value['is_wallet']) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewWalletPage(
                  title: value['title'],
                  orderId: widget.orderId,
                  methodId: value['id'],
                  data: widget.data))).then((value) {
        if (value == "success") Navigator.pop(context, widget.data);
      });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewPaymentPage(
                  title: value['title'],
                  orderId: widget.orderId,
                  methodId: value['id']))).then((value) {
        if (value == "success") Navigator.pop(context, widget.data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: loader
              ? const SizedBox(height: 300, child: LoaderComponent())
              : ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Column(children: [
                    AppBar(
                        centerTitle: false,
                        automaticallyImplyLeading: false,
                        actions: const [
                          CloseIconButton(iconColor: null, padding: true)
                        ],
                        title: const Text("Способ оплаты")),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: data.map((value) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: ColorComponent.gray['100']!))),
                            child: ListTile(
                                onTap: () => showPaymentPage(value),
                                trailing:
                                    SvgPicture.asset('assets/icons/right.svg'),
                                title: Text(value['title'],
                                    style: const TextStyle(fontSize: 15))),
                          );
                        }).toList()
                        // [
                        //   ListTile(
                        //       trailing: SvgPicture.asset('assets/icons/right.svg'),
                        //       title: const Text("Карта (Visa/MasterCard)",
                        //           style: TextStyle(fontSize: 15))),
                        //   Divider(height: 1, color: ColorComponent.gray['100']),
                        //   ListTile(
                        //       trailing: SvgPicture.asset('assets/icons/right.svg'),
                        //       title: const Text("Личный счет",
                        //           style: TextStyle(fontSize: 15))),
                        //   Divider(height: 1, color: ColorComponent.gray['100']),
                        //   ListTile(
                        //       trailing: SvgPicture.asset('assets/icons/right.svg'),
                        //       title: const Text(
                        //           "С оператором (Beeline, Tele2, Altel и др.)",
                        //           style: TextStyle(fontSize: 15)))
                        // ],
                        ),
                    Divider(height: MediaQuery.of(context).padding.bottom + 15)
                  ]),
                ),
        ),
      ],
    );
  }
}
