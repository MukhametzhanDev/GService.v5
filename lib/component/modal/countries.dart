import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class Countries extends StatefulWidget {
  final void Function(Map value) onPressed;
  final Map data;
  const Countries({super.key, required this.onPressed, required this.data});

  @override
  State<Countries> createState() => _CountriesState();
}

class _CountriesState extends State<Countries>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  List data = [];
  List filterData = [];
  bool loader = true;
  bool _showScrollToTopButton = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    getData();
    scrollController.addListener(() => _scrollListener());
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  Future getData() async {
    try {
      Response response = await dio.get("/countries");
      print(response.data);
             if (response.statusCode==200) {

        data = response.data['data'];
        filterData = response.data['data'];
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

  void addTitle(String value) {
    if (value.isNotEmpty) {
      filterData = data
          .where((element) =>
              element['title'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      filterData = data;
    }
    setState(() {});
  }

  void _scrollListener() {
    if (scrollController.offset > 0 && !_showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = true;
      });
      _animationController.forward();
    } else if (scrollController.offset <= 0 && _showScrollToTopButton) {
      _animationController.reverse().then((_) {
        setState(() {
          _showScrollToTopButton = false;
        });
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void savedData(Map value) {
    Navigator.pop(context);
    // showCupertinoModalBottomSheet(
    //     context: context,
    //     builder: (context) =>
    //         Cities(onPressed: widget.onPressed, countryData: value));
  }

  int getIdCurrent() {
    if (widget.data.isNotEmpty) {
      return widget.data['country']['id'];
    } else {
      return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: Container(),
          leadingWidth: 0,
          title: Text("Выберите страны",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          actions: [CloseIconButton(iconColor: null, padding: true)],
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 60),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                child:
                    SearchTextField(title: "Поиск страны", onChanged: addTitle),
              )),
        ),
        body: loader
            ? LoaderComponent()
            : ListView.builder(
                physics: physics,
                controller: scrollController,
                itemCount: filterData.length,
                itemBuilder: (context, index) {
                  Map item = filterData[index];
                  bool currentItem = item['id'] == getIdCurrent();
                  return Container(
                    decoration: BoxDecoration(
                        color: currentItem ? ColorComponent.gray['100'] : null,
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Color(0xfff4f5f7)))),
                    child: ListTile(
                      onTap: () {
                        savedData(item);
                      },
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: SvgPicture.network(item['flag'], width: 20)),
                      title: Text(item['title'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      trailing: Container(
                        width: 18,
                        child: SvgPicture.asset(
                            currentItem
                                ? 'assets/icons/check.svg'
                                : 'assets/icons/right.svg',
                            color: currentItem
                                ? ColorComponent.blue['500']
                                : null),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FadeTransition(
          opacity: _fadeAnimation,
          child: FloatingActionButton(
            onPressed: () {
              _scrollToTop();
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1.5,
            backgroundColor: ColorComponent.mainColor,
            child: const Icon(Icons.navigation),
          ),
        ),
      );
    });
  }
}
