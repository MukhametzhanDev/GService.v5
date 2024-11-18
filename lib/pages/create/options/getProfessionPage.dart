import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/pages/create/data/createData.dart';

class GetProfessionPage extends StatefulWidget {
  final void Function() nextPage;
  const GetProfessionPage(
      {super.key, required this.nextPage});

  @override
  State<GetProfessionPage> createState() =>
      _GetProfessionPageState();
}

class _GetProfessionPageState
    extends State<GetProfessionPage> {
  List data = [];
  bool loader = true;
  ScrollController scrollController = ScrollController();
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  String title = "";

  @override
  void initState() {
    getData();
    scrollController.addListener(() {
      loadMoreAd();
    });
    super.initState();
  }

  Future getData() async {
    try {
      Response response =
          await dio.get("/professions", queryParameters: {"title": title});
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  void loadMoreAd() async {
    if (scrollController.position.extentAfter < 200 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Response response = await dio.get("/professions",
            queryParameters: {"page": page.toString(), "title": title});
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});
        } else {
          SnackBarComponent().showResponseErrorMessage(response, context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  void activedItem(Map value) {
    CreateData.data['profession_id'] = value['id'];
    widget.nextPage();
  }

  void searchList(value) {
    title = value;
    loader = true;
    setState(() {});
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
          child: SearchTextField(title: "Поиск", onChanged: searchList)),
      Expanded(
        child: loader
            ? LoaderComponent()
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15),
                itemCount: data.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  Map value = data[index];
                  if (data.length - 1 == index) {
                    return Column(children: [
                      Item(value),
                      isLoadMore ? LoaderPaginationComponent() : Container()
                    ]);
                  } else {
                    return Item(value);
                  }
                }),
      )
    ]);
  }

  Widget Item(Map value) {
    bool active = value['active'] ?? false;
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xffF5f5f5)))),
      child: ListTile(
        onTap: () => activedItem(value),
        title: Text(value['title']),
        trailing: SvgPicture.asset('assets/icons/right.svg'),
      ),
    );
  }
}
