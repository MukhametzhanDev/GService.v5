import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class CountryCodeListModal extends StatefulWidget {
  const CountryCodeListModal({super.key});

  @override
  State<CountryCodeListModal> createState() => _CountryCodeListModalState();
}

class _CountryCodeListModalState extends State<CountryCodeListModal> {
  ScrollController scrollController = ScrollController();
  List data = [];
  List filterData = [];
  bool loader = true;
  bool hasNextPage = true;
  bool isLoadMore = false;
  int page = 1;
  String title = "";

  @override
  void initState() {
    super.initState();
    getData();
    scrollController.addListener(() => loadMoreAd());
  }

  Future getData() async {
    try {
      page = 1;
      Response response = await dio
          .get("/countries", queryParameters: {"title": title, "page": page});
      print(response.data);
      if (response.statusCode == 200) {
        data = response.data['data'];
        filterData = response.data['data'];
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
        Response response = await dio
            .get("/countries", queryParameters: {"title": title, "page": page});
        print(response.data);
        if (response.statusCode == 200) {
          data.addAll(response.data['data']);
          filterData.addAll(response.data['data']);
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void savedData(Map value) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Выберите код страны"),
          leading: Container(),
          leadingWidth: 0,
          elevation: 0,
          actions: const [CloseIconButton(iconColor: null, padding: true)],
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 56),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: SearchTextField(
                    title: context.localizations.search,
                    onChanged: (value) {
                      title = value;
                      getData();
                    }),
              )),
        ),
        body: loader
            ? LoaderComponent()
            : ListView.builder(
                itemCount: filterData.length,
                physics: physics,
                controller: scrollController,
                itemBuilder: (context, index) {
                  Map value = filterData[index];
                  return Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(
                                width: 1, color: Color(0xffe5e7eb)))),
                    child: ListTile(
                      onTap: () {
                        closeKeyboard();
                        Navigator.pop(context, value);
                      },
                      leading: SvgPicture.network(value['flag'], width: 24),
                      title: Text(
                        value['title'],
                        style: const TextStyle(fontSize: 15),
                      ),
                      trailing: Text(
                        "+${value['phone_code']}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
