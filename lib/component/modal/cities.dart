import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/closeIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class Cities extends StatefulWidget {
  final void Function(Map value) onPressed;
  final int countryId;
  const Cities({super.key, required this.onPressed, required this.countryId});

  @override
  State<Cities> createState() => _CitiesState();
}

class _CitiesState extends State<Cities> with SingleTickerProviderStateMixin {
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
      Response response = await dio
          .get("/cities", queryParameters: {"country_id": widget.countryId});
      print(response.data);
             if (response.statusCode==200) {

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
    widget.onPressed(value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: Container(),
          leadingWidth: 0,
          title: Text("Выберите город",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          actions: [CloseIconButton(iconColor: null, padding: true)],
          bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 60),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                child: SearchTextField(
                    title: "Поиск город", onChanged: (value) {}),
              )),
        ),
        body: loader
            ? LoaderComponent()
            : ListView.builder(
                physics: physics,
                controller: scrollController,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Map item = data[index];
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Color(0xfff4f5f7)))),
                    child: ListTile(
                        onTap: () {
                          savedData(item);
                        },
                        title: Text(item['title'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500))),
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
