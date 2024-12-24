import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';

class ViewPaymentPage extends StatefulWidget {
  final String orderId;
  final int methodId;
  const ViewPaymentPage(
      {super.key, required this.orderId, required this.methodId});

  @override
  State<ViewPaymentPage> createState() => _ViewPaymentPageState();
}

class _ViewPaymentPageState extends State<ViewPaymentPage> {
  String url = "";
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      print({"order_id": widget.orderId, "method_id": widget.methodId});
      Response response = await dio.post("/make-payment", data: {
        "order_id": widget.orderId,
        "payment_method_id": widget.methodId
      });
      print("DATA ${response.data}");
      if (response.data['success']) {
        url = response.data['data'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackIconButton()),
    );
  }
}
