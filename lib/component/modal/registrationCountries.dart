import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/closeIconButton.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/paginationLoaderComponent.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/searchTextField.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class RegistrationCountries extends StatefulWidget {
  final void Function(Map value) onPressed;
  final Map data;
  const RegistrationCountries(
      {super.key, required this.onPressed, required this.data});

  @override
  State<RegistrationCountries> createState() => _RegistrationCountriesState();
}

class _RegistrationCountriesState extends State<RegistrationCountries>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  List data = [];
  bool _showScrollToTopButton = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool hasNextPage = false;
  bool isLoadMore = false;
  int page = 1;
  bool loader = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() => _scrollListener());
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    getData('');
  }

  Future getData(title) async {
    print(title);
    page = 1;
    setState(() {});
    try {
      Map<String, dynamic> parameter = {"page": page, "title": title};
      Response response =
          await dio.get("/countries", queryParameters: parameter);
      print(response.data);
             if (response.statusCode==200) {

        data = response.data['data'];
        hasNextPage = page != response.data['meta']['last_page'];
        loader = false;
        setState(() {});
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } catch (e) {
      SnackBarComponent().showNotGoBackServerErrorMessage(context);
    }
  }

  Future loadMore() async {
    if (scrollController.position.extentAfter < 200 &&
        hasNextPage &&
        !isLoadMore) {
      try {
        isLoadMore = true;
        page += 1;
        setState(() {});
        Map<String, dynamic> parameter = {"page": page};
        Response response =
            await dio.get("/countries", queryParameters: parameter);
        print(response.data);
               if (response.statusCode==200) {

          data.addAll(response.data['data']);
          hasNextPage = page != response.data['meta']['last_page'];
          isLoadMore = false;
          setState(() {});
        } else {
          SnackBarComponent()
              .showErrorMessage(response.data['message'], context);
        }
      } catch (e) {
        SnackBarComponent().showNotGoBackServerErrorMessage(context);
      }
    }
  }

  void addTitle(String value) {
    getData(value);
  }

  void _scrollListener() {
    loadMore();
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

  int getIdCurrent() {
    if (widget.data.isNotEmpty) {
      return widget.data['id'];
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
        body: ListView.builder(
          physics: physics,
          controller: scrollController,
          itemCount: data.length,
          itemBuilder: (context, index) {
            Map item = data[index];
            bool currentItem = item['id'] == getIdCurrent();
            if (isLoadMore) PaginationLoaderComponent();
            return Container(
              decoration: BoxDecoration(
                  color: currentItem ? ColorComponent.gray['100'] : null,
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xfff4f5f7)))),
              child: ListTile(
                onTap: () {
                  savedData(item);
                },
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: SvgPicture.network(item['flag'], width: 20)),
                title: Text(item['title'],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                trailing: Container(
                  width: 18,
                  child: SvgPicture.asset(
                      currentItem
                          ? 'assets/icons/check.svg'
                          : 'assets/icons/right.svg',
                      color: currentItem ? ColorComponent.blue['500'] : null),
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
