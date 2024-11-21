import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';

class GetSelectPage extends StatefulWidget {
  final String title;
  final Map value;
  final Map param;
  final List options;
  final PageController pageController;
  final void Function() showOptionsPage;
  const GetSelectPage(
      {super.key,
      required this.title,
      required this.value,
      required this.param,
      required this.options,
      required this.showOptionsPage,
      required this.pageController});

  @override
  State<GetSelectPage> createState() => _GetSelectPageState();
}

class _GetSelectPageState extends State<GetSelectPage>
    with AutomaticKeepAliveClientMixin {
  List data = [];
  bool loader = true;
  ScrollController scrollController = ScrollController();
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  String title = "";
  List multipleData = [];
  int currentId = -1;

  @override
  void initState() {
    print("API ${widget.value['url']}");
    getData();
    scrollController.addListener(() {
      loadMoreAd();
    });
    super.initState();
  }

  Future getData() async {
    print(widget.param);
    try {
      Response response = await dio.get(widget.value['url'],
          queryParameters: {"title": title, ...widget.param});
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        activedData(data);
        loader = false;
        hasNextPage = page != response.data['meta']['last_page'];
        setState(() {});
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e);
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
        Response response = await dio.get(widget.value['url'],
            queryParameters: {
              "page": page.toString(),
              "title": title,
              ...widget.param
            });
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
          activedData(data);
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

  void activedData(List data) {
    final idsSet = multipleData.toSet();
    data.map((item) {
      if (idsSet.contains(item['id'])) {
        item['active'] = true;
      }
    }).toList();
  }

  void activedItem(Map value) {
    if (widget.value['multiple']) {
      if (value['active'] ?? false) {
        value['active'] = false;
        multipleData.remove(value['id']);
      } else {
        value['active'] = true;
        multipleData.add(value['id']);
      }
    } else {
      CreateData.data[widget.value['name']] = value['id'];
      currentId = value['id'];
      nextPage();
    }
    setState(() {});
  }

  void savedData() {
    CreateData.data[widget.value['name']] = multipleData;
    nextPage();
  }

  void nextPage() {
    widget.showOptionsPage();
    // widget.pageController
    //     .nextPage(duration: Duration(milliseconds: 400), curve: Curves.linear);
    // int nextPage = (widget.pageController.page ?? 0).toInt() + 1;
    // widget.pageController.jumpToPage(nextPage);
  }

  void previousPage() {
    int nextPage = (widget.pageController.page ?? 0).toInt() - 1;
    if (nextPage > 1) {
      Navigator.pop(context);
    } else {
      widget.pageController.jumpToPage(nextPage);
    }
  }

  void searchList(value) {
    title = value;
    loader = true;
    setState(() {});
    getData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width - 100,
          leading: BackTitleButton(
              title: widget.title, onPressed: () => Navigator.pop(context))),
      body: Column(children: [
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
      ]),
      bottomNavigationBar: widget.value['multiple']
          ? BottomNavigationBarComponent(
              child: Button(
                  onPressed: () => savedData(),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  title: "Продолжить"))
          : null,
    );
  }

  Widget Item(Map value) {
    bool active = value['active'] ?? false;
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xffF5f5f5)))),
      child: ListTile(
        onTap: () => activedItem(value),
        title: Text(value['title']),
        trailing: widget.value['multiple']
            ? CheckItem(active)
            : value['id'] == currentId
                ? SvgPicture.asset('assets/icons/checkMini.svg',
                    width: 20, color: ColorComponent.blue['500'])
                : SvgPicture.asset('assets/icons/right.svg'),
      ),
    );
  }

  Widget CheckItem(bool active) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: active ? ColorComponent.blue['500'] : Colors.white,
          border: Border.all(
              width: 1, color: active ? Color(0xff3f83f8) : Color(0xff9fa6b2)),
          borderRadius: BorderRadius.circular(4)),
      child: active
          ? SvgPicture.asset('assets/icons/check.svg', color: Colors.white)
          : Container(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => currentId != -1;
}
