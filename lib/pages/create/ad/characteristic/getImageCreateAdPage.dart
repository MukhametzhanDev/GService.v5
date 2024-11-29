import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/getImageWidget.dart';
import 'package:image_picker/image_picker.dart';

class GetImageCreateAdPage extends StatefulWidget {
  final void Function() previousPage;
  const GetImageCreateAdPage({super.key, required this.previousPage});

  @override
  State<GetImageCreateAdPage> createState() => _GetImageCreateAdPageState();
}

class _GetImageCreateAdPageState extends State<GetImageCreateAdPage> {
  List imagesPath = [];
  List imagesUrl = [];

  Future postData(List images) async {
    showModalLoader(context);
    CreateData.characteristic
        .removeWhere((key, value) => value is Map<String, dynamic>);
    CreateData.data.removeWhere((key, value) => value is Map<String, dynamic>);
    print(CreateData.data);
    FormData formData = FormData.fromMap({
      "images": images,
      ...CreateData.data,
      "characteristic": CreateData.characteristic,
      "country_id": 1
    }, ListFormat.multiCompatible);
    try {
      Response response = await dio.post("/ad", data: formData);
      print(response.data);
      if (response.data['success'] && response.statusCode == 200) {
        CreateData.data.clear();
        CreateData.images.clear();
        CreateData.characteristic.clear();
        Navigator.pop(context);
        Navigator.pop(context, "ad");
        Navigator.pop(context, "ad");
        Navigator.pop(context, "ad");
      } else {
        Navigator.pop(context);
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e.stackTrace);
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

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
        await postData(response.data['data']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 15),
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
              padding: EdgeInsets.symmetric(horizontal: 15),
              title: "Опубликовать"),
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
