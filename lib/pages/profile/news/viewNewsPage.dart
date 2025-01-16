import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/shareButton.dart';
import 'package:gservice5/component/date/formattedDate.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/author/authorAdWidget.dart';

class ViewNewsPage extends StatefulWidget {
  final int id;
  const ViewNewsPage({super.key, required this.id});

  @override
  State<ViewNewsPage> createState() => _ViewNewsPageState();
}

class _ViewNewsPageState extends State<ViewNewsPage> {
  Map data = {};
  bool loader = true;
  List<Map<String, String>> comments = [];
  TextEditingController commentController = TextEditingController();
  int commentsToShow = 3;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/news/${widget.id}");
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void addComment(String text) {
    setState(() {
      comments.add({
        "user": "user",
        "text": text,
        "created_at": DateTime.now().toString(),
      });
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    List tags = data['news_tags'] ?? [];
    data['author']['is_company'] = true;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          leadingWidth: 200,
          leading: BackTitleButton(
              title: "Новость", onPressed: () => Navigator.pop(context)),
          actions: const [
            ShareButton(
              id: 0,
              hasAd: false,
              frompage: GAParams.viewNewsPage,
            ),
            Divider(indent: 16)
          ]),
      body: loader
          ? const LoaderComponent()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data["title"],
                            maxLines: 3,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                        const Divider(height: 12),
                        Row(children: [
                          Text(
                              formattedDate(
                                  data["created_at"], "dd MMMM yyyy, HH:mm"),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: ColorComponent.gray['500'])),
                          const Divider(indent: 16),
                          SvgPicture.asset("assets/icons/eye.svg"),
                          const Divider(indent: 4),
                          Text(data["views"].toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: ColorComponent.gray['500']))
                        ]),
                        const Divider(indent: 12),
                        CacheImage(
                            url: data["poster"],
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            borderRadius: 10),
                        const Divider(indent: 12),
                        Text(data["short_description"],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        const Divider(indent: 8),
                        Text(data["description"]),
                        // Divider(indent: 16),
                        // Text("Комментарии",
                        //     style:
                        //         TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        // Divider(indent: 8),
                        // ListView.builder(
                        //     padding: EdgeInsets.zero,
                        //     shrinkWrap: true,
                        //     physics: NeverScrollableScrollPhysics(),
                        //     itemCount: commentsToShow > comments.length
                        //         ? comments.length
                        //         : commentsToShow,
                        //     itemBuilder: (context, index) {
                        //       return Padding(
                        //           padding: const EdgeInsets.symmetric(vertical: 8.0),
                        //           child: Row(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 SvgPicture.asset(
                        //                     "assets/icons/avatarCircle.svg"),
                        //                 Divider(indent: 8),
                        //                 Expanded(
                        //                     child: Column(
                        //                         crossAxisAlignment:
                        //                             CrossAxisAlignment.start,
                        //                         children: [
                        //                       Text("@${comments[index]['user']}",
                        //                           style: TextStyle(
                        //                               fontWeight: FontWeight.w700)),
                        //                       Divider(indent: 8),
                        //                       Text(comments[index]['text']!),
                        //                       Divider(indent: 8),
                        //                       Text(
                        //                           formattedDateNews(
                        //                               comments[index]['created_at']!),
                        //                           style: TextStyle(
                        //                               fontSize: 12,
                        //                               fontWeight: FontWeight.w500,
                        //                               color:
                        //                                   ColorComponent.gray['500']))
                        //                     ]))
                        //               ]));
                        //     }),
                        // if (comments.length > commentsToShow)
                        //   GestureDetector(
                        //     onTap: () {
                        //       setState(() {
                        //         commentsToShow += 5;
                        //       });
                        //     },
                        //     child: Container(
                        //         color: ColorComponent.gray['200'],
                        //         margin: EdgeInsets.only(top: 12, bottom: 12),
                        //         padding: EdgeInsets.only(top: 8, bottom: 8),
                        //         child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Text("Показать еще",
                        //                   style: TextStyle(
                        //                       fontSize: 13,
                        //                       fontWeight: FontWeight.w500)),
                        //             ])),
                        //   ),
                        // Container(
                        //     padding: EdgeInsets.only(
                        //         left: 16, right: 16, top: 12, bottom: 12),
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(14),
                        //         border: Border.all(
                        //             width: 1, color: Colors.grey.withOpacity(0.3))),
                        //     child: Row(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           SvgPicture.asset("assets/icons/avatarCircle.svg"),
                        //           Expanded(
                        //               child: TextField(
                        //                   onSubmitted: (value) {},
                        //                   autofocus: false,
                        //                   maxLines: 3,
                        //                   keyboardType: TextInputType.emailAddress,
                        //                   style: TextStyle(fontSize: 14, height: 1.1),
                        //                   controller: commentController,
                        //                   decoration: InputDecoration(
                        //                       fillColor: Colors.transparent,
                        //                       hintText: "Ваш комментарии",
                        //                       focusedBorder: InputBorder.none,
                        //                       enabledBorder: InputBorder.none,
                        //                       border: InputBorder.none)))
                        //         ])),
                        // Divider(height: 12),
                        // Button(
                        //     onPressed: () {
                        //       if (commentController.text.isNotEmpty) {
                        //         addComment(commentController.text);
                        //       }
                        //     },
                        //     backgroundColor: ColorComponent.mainColor,
                        //     titleColor: Colors.black,
                        //     icon: null,
                        //     padding: EdgeInsets.zero,
                        //     widthIcon: null,
                        //     title: "Отправить"),
                        const Divider(height: 16),
                        Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: tags.map((value) {
                              return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: ColorComponent.mainColor
                                          .withOpacity(.2),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text(value['title'],
                                      style: const TextStyle(fontSize: 12)));
                            }).toList()),
                        const Divider(height: 8),
                      ],
                    ),
                  ),
                  AuthorAdWidget(
                      title: "Автор",
                      data: data['author'],
                      showOtherAd: false,
                      id: data['id']),
                  Divider(height: MediaQuery.of(context).padding.bottom + 15),
                ],
              ),
            ),
    );
  }
}
