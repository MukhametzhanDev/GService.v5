import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/getImageWidget.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:image_picker/image_picker.dart';

class GetImageCreateAdPage extends StatefulWidget {
  final void Function() previousPage;
  final void Function() nextPage;
  const GetImageCreateAdPage(
      {super.key, required this.previousPage, required this.nextPage});

  @override
  State<GetImageCreateAdPage> createState() => _GetImageCreateAdPageState();
}

class _GetImageCreateAdPageState extends State<GetImageCreateAdPage> {
  List imagesPath = [];
  List imagesUrl = [];
  PageControllerIndexedStack pageControllerIndexedStack =
      PageControllerIndexedStack();

  Future postImage() async {
    showModalImageLoader(context);
    try {
      FormData formData = FormData.fromMap({
        "image": [
          for (XFile file in imagesPath)
            {
              await MultipartFile.fromFile(file.path,
                  filename: file.path.split('/').last)
            }.toList()
        ]
      });
      Response response = await dio.post("/image/store", data: formData);
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        CreateData.data['images'] = response.data['data'];
        savedData();
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void savedData() {
    pageControllerIndexedStack.nextPage();
    widget.nextPage();
  }

  void verifyData() {
    if (imagesPath.isEmpty) {
      SnackBarComponent().showErrorMessage("Загрузите изображения", context);
    } else {
      postImage();
    }

    GetIt.I<FirebaseAnalytics>().logEvent(
        name: GAEventName.buttonClick,
        parameters: {
          'button_name': GAParams.btnImageContinue
        }).catchError((onError) => debugPrint(onError));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 15, left: 15),
                child: Text("Загрузите изображение",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
            GetImageWidget(onImagesSelected: (value) {
              imagesPath = value;
              setState(() {});
            })
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Column(
        children: [
          Button(
              onPressed: verifyData,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Продолжить"),
          // Divider(height: 4),
          // Button(
          //     onPressed: postData,
          //     backgroundColor: Colors.white,
          //     padding: EdgeInsets.symmetric(horizontal: 15),
          //     title: "Пропустить"),
        ],
      )),
    );
  }
}
