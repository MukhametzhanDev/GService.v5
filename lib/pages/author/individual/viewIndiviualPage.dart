import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';

class ViewIndiviualPage extends StatefulWidget {
  final int id;
  const ViewIndiviualPage({super.key, required this.id});

  @override
  State<ViewIndiviualPage> createState() => _ViewIndiviualPageState();
}

class _ViewIndiviualPageState extends State<ViewIndiviualPage> {
  Map data = {}; //data from api
  bool loader = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/company/${widget.id}");
      if (response.statusCode == 200) {
        setState(() {
          data = response.data['data'];
          loader = false;
        });
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
      appBar: AppBar(
        leading: BackIconButton(),
        actions: [ShareButton(id: 0, hasAd: false), Divider(indent: 15)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                child: Row(
                  children: [
                    CacheImage(
                        url:
                            "https://images.unsplash.com/photo-1720048171419-b515a96a73b8?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMXx8fGVufDB8fHx8fA%3D%3D",
                        width: 60,
                        height: 60,
                        borderRadius: 30),
                    Divider(indent: 15),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600))
                      ],
                    ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
