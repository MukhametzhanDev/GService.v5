import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:share_plus/share_plus.dart';

class ViewReceiptPage extends StatefulWidget {
  const ViewReceiptPage({super.key});

  @override
  State<ViewReceiptPage> createState() => _ViewReceiptPageState();
}

class _ViewReceiptPageState extends State<ViewReceiptPage> {
  Future shareFile() async {
    await Share.shareUri(Uri.parse(
        "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackIconButton(),
        actions: [
          IconButton(
              onPressed: () async => shareFile(),
              icon: SvgPicture.asset("assets/icons/share.svg"))
        ],
      ),
      body: const PDF().fromUrl(
        "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
