import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';

class ViewPaymentPage extends StatefulWidget {
  final String orderId;
  final String title;
  final int methodId;
  const ViewPaymentPage(
      {super.key,
      required this.orderId,
      required this.methodId,
      required this.title});

  @override
  State<ViewPaymentPage> createState() => _ViewPaymentPageState();
}

class _ViewPaymentPageState extends State<ViewPaymentPage> {
  String url = "";
  bool loader = true;
  bool webLoader = true;

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

  void verifyStatus(String url) {
    bool success = url.contains("success");
    bool failed = url.contains("failure");
    if (failed) {
      Navigator.pop(context);
    } else if (success) {
      Navigator.pop(context, "success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackTitleButton(title: widget.title), leadingWidth: 300),
      body: loader
          ? const LoaderComponent()
          : Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(url)),
                  onConsoleMessage:
                      (controller, ConsoleMessage consoleMessage) {
                    debugPrint(
                        "------>{consoleMessage.message${consoleMessage.message}");
                    debugPrint(
                        "------>{consoleMessage.messageLevel${consoleMessage.messageLevel}");
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      webLoader = true;
                    });
                  },
                  onLoadStop: (controller, url) async {
                    setState(() {
                      webLoader = false;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, isReload) {
                    verifyStatus(url.toString());
                    if (isReload ?? false) {
                      Navigator.pop(context);
                    }
                  },
                ),
                if (webLoader)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}
