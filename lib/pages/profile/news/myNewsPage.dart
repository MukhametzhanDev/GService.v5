import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/profile/news/allNewsPage.dart';
import 'package:gservice5/pages/profile/news/viewNewsPage.dart';

class MyNewsPage extends StatefulWidget {
  const MyNewsPage({super.key});

  @override
  State<MyNewsPage> createState() => _MyNewsPageState();
}

class _MyNewsPageState extends State<MyNewsPage> {
  List data = [];
  bool loader = !true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/my-news");
      if (response.data['success']) {
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

  @override
  Widget build(BuildContext context) {
    return loader
        ? LoaderComponent()
        : data.isEmpty
            ? Container()
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewNewsPage(id: data[index]['id'])));
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CacheImage(
                                url: data[index]["poster"],
                                width: 120,
                                height: 94,
                                borderRadius: 12),
                            Divider(indent: 12),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data[index]["title"],
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    Divider(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                            formattedDateNews(
                                                data[index]["created_at"]),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: ColorComponent
                                                    .gray['500'])),
                                        Divider(indent: 24),
                                        SvgPicture.asset(
                                            "assets/icons/eye.svg"),
                                        Divider(indent: 4),
                                        Text(data[index]["views"].toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: ColorComponent
                                                    .gray['500'])),
                                      ],
                                    ),
                                  ]),
                            )
                          ],
                        ),
                        Divider(height: 16),
                        Divider(height: 1, color: ColorComponent.gray['100'])
                      ],
                    ),
                  );
                });
  }
}
