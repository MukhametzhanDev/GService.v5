import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/loaderComponent.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/modal/modalBottomSheetWrapper.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/textField/closeKeyboard/closeKeyboard.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class CancelApplicationModal extends StatefulWidget {
  final int id;
  const CancelApplicationModal({super.key, required this.id});

  @override
  State<CancelApplicationModal> createState() => _CancelApplicationModalState();
}

class _CancelApplicationModalState extends State<CancelApplicationModal> {
  List data = [];
  bool loader = true;
  int? currentIndex;
  TextEditingController descEditingController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      Response response = await dio.get("/application-cancellation-tags");
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

  Future postData(Map param) async {
    showModalLoader(context);
    try {
      Response response =
          await dio.post("/cancel-application/${widget.id}", data: param);
      Navigator.pop(context);
      if (response.data['success']) {
        Navigator.pop(context, "update");
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void verifyData() async {
    String desc = descEditingController.text.trim();
    if (currentIndex == null) {
      SnackBarComponent()
          .showErrorMessage("Выберите один из предложенных вариантов", context);
    } else if (data[currentIndex!]['with_description'] && desc.isEmpty) {
      SnackBarComponent()
          .showErrorMessage("Поделитесь своим мнением", context);
    } else {
      Map<String, dynamic> param = {};
      if (currentIndex != null) {
        param = {
          "application_cancellation_tag_id": data[currentIndex!]['id'],
          "description": data[currentIndex!]['title']
        };
      } else {
        param = {"description": descEditingController.text};
      }
      await postData(param);
    }
  }

  void activedItem(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrapper(builder: (context, physics) {
      return GestureDetector(
        onTap: () => closeKeyboard(),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Почему вы хотите удалить?"),
            centerTitle: false,
            actions: const [CloseIconButton(iconColor: null, padding: true)],
          ),
          body: loader
              ? const LoaderComponent()
              : SingleChildScrollView(
                  physics: physics,
                  child: Column(
                    children: [
                      Column(
                          children: data.map((value) {
                        int index = data.indexOf(value);
                        bool active = currentIndex == index;
                        return GestureDetector(
                          onTap: () => activedItem(index),
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xfff4f5f7)))),
                            child: ListTile(
                                leading: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                        color: active
                                            ? Colors.white
                                            : const Color(0xffe5e7eb),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            width: active ? 5 : 0,
                                            color: active
                                                ? const Color(0xff1A56DB)
                                                : const Color(0xffe5e7eb)))),
                                title: Text(value['title'])),
                          ),
                        );
                      }).toList()),
                      currentIndex != null &&
                              data[currentIndex!]['with_description']
                          ? Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextField(
                                  controller: descEditingController,
                                  style: const TextStyle(fontSize: 14),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  maxLines: 10,
                                  minLines: 6,
                                  decoration: InputDecoration(
                                      hintText: "Что-то другое?",
                                      helperStyle: TextStyle(
                                          color: ColorComponent.gray['500']))),
                            )
                          : Container(),
                      const Divider(height: 16),
                      Button(
                          onPressed: verifyData,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          title: "Отправить и удалить"),
                      const Divider(height: 8),
                      Button(
                          onPressed: () => Navigator.pop(context),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          backgroundColor: Colors.white,
                          title: "Назад")
                    ],
                  ),
                ),
        ),
      );
    });
  }
}
