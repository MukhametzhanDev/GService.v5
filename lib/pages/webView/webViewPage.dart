import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool webLoader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackIconButton()),
      body: webLoader
          ? const LoaderComponent()
          : Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(widget.url)),
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
                  onLoadError: (controller, url, code, message) {
                    print(message);
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
