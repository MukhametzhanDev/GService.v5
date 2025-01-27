import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/provider/adFilterProvider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class FilterSelectModal extends StatefulWidget {
  final String title;
  final String api;
  final Map option;
  final Map value;
  final Map Function(Map data) param;
  const FilterSelectModal(
      {super.key,
      required this.title,
      required this.api,
      required this.option,
      required this.value,
      required this.param});

  @override
  State<FilterSelectModal> createState() => _FilterSelectModalState();
}

class _FilterSelectModalState extends State<FilterSelectModal> {
  Map currentData = {};

  @override
  void initState() {
    currentData = widget.value;
    // addData();
    super.initState();
  }

  // void addData() {
  //   if (widget.value.containsKey("id")) {
  //     Provider.of<AdFilterProvider>(context, listen: false).filterData = {
  //       widget.option['name']: widget.value['id']
  //     };
  //   }
  // }

  void showModal() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => SelectModal(
            title: widget.title,
            api: widget.api,
            param: widget.param,
            option: widget.option,
            data: widget.value)).then((value) {
      if (value != null) {
        print(value);
        currentData = value;
        Provider.of<AdFilterProvider>(context, listen: false).filterData = {
          widget.option['name']: value['id'],
          "${widget.option['name']}_value": value
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showModal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const Divider(height: 6),
          Container(
            height: 48,
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xffF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: const Color(0xffE5E5EA))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(currentData['title'] ?? "Выберите",
                      style: TextStyle(
                          color: currentData.isEmpty
                              ? ColorComponent.gray['500']
                              : Colors.black,
                          overflow: TextOverflow.ellipsis)),
                ),
                SvgPicture.asset('assets/icons/down.svg')
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SelectModal extends StatefulWidget {
  final String title;
  final String api;
  final Map data;
  final Map option;
  final Map Function(Map data) param;
  const SelectModal(
      {super.key,
      required this.title,
      required this.api,
      required this.data,
      required this.option,
      required this.param});

  @override
  State<SelectModal> createState() => _SelectModalState();
}

class _SelectModalState extends State<SelectModal> {
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future getData() async {
    try {
      page = 1;
      Map param = widget.param(widget.option);
      print("widget.param $param");
      setState(() {});
      Response response = await dio.get(widget.api,
          queryParameters: {"title": title, "page": page, ...param});
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        loader = false;
        hasNextPage = page != (response.data['meta']?['last_page'] ?? 1);
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
    if (scrollController.position.extentAfter < 100 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        Map param = widget.param(widget.option);
        setState(() {});
        Response response = await dio.get(widget.api, queryParameters: {
          "page": page.toString(),
          "title": title,
          ...param
        });
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
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: false,
          actions: const [CloseIconButton(iconColor: null, padding: true)],
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 50),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  child: SearchTextField(
                      title: "Поиск",
                      onChanged: (value) {
                        title = value;
                        getData();
                      }))),
        ),
        body: loader
            ? const LoaderComponent()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 15),
                physics: physics,
                controller: scrollController,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Map value = data[index];
                  bool active = value['id'] == widget.data['id'];
                  if (data.length - 1 == index) {
                    return Column(children: [
                      ListItem(value, active),
                      hasNextPage
                          ? const PaginationLoaderComponent()
                          : Container()
                    ]);
                  } else {
                    return ListItem(value, active);
                  }
                }),
      );
    });
  }

  Widget ListItem(Map value, bool active) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xffeeeeee)))),
      child: ListTile(
        onTap: () => activedItem(value),
        title: Text(value['title']),
        trailing: active
            ? SvgPicture.asset(
                'assets/icons/checkMini.svg',
                color: ColorComponent.blue['500'],
                width: 20,
              )
            : SvgPicture.asset('assets/icons/right.svg'),
      ),
    );
  }
}
