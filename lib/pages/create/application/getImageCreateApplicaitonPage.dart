import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/getImageWidget.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:image_picker/image_picker.dart';

class GetImageCreateApplicaitonPage extends StatefulWidget {
  final void Function() nextPage;
  const GetImageCreateApplicaitonPage({super.key, required this.nextPage});

  @override
  State<GetImageCreateApplicaitonPage> createState() =>
      _GetImageCreateApplicaitonPageState();
}

class _GetImageCreateApplicaitonPageState
    extends State<GetImageCreateApplicaitonPage> {
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
      Response response = await dio.post("/image/application", data: formData);
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        CreateData.data['images'] = response.data['data'];
        nextPage();
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void verifyData() {
    if (imagesPath.isEmpty) {
      SnackBarComponent().showErrorMessage("Загрузите изображения", context);
    } else {
      postImage();
    }
  }

  void nextPage() {
    pageControllerIndexedStack.nextPage();
    widget.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
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
          const Divider(height: 4),
          Button(
              onPressed: nextPage,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Пропустить"),
        ],
      )),
    );
  }
}
