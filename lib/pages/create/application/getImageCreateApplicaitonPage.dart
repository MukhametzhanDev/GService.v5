import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/backIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/request/verifyContact.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/create/getImageWidget.dart';
import 'package:gservice5/pages/profile/contacts/addContactsPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class GetImageCreateApplicaitonPage extends StatefulWidget {
  const GetImageCreateApplicaitonPage({super.key});

  @override
  State<GetImageCreateApplicaitonPage> createState() =>
      _GetImageCreateApplicaitonPageState();
}

class _GetImageCreateApplicaitonPageState
    extends State<GetImageCreateApplicaitonPage> {
  List imagesPath = [];
  List imagesUrl = [];

  Future postData() async {
    showModalLoader(context);
    CreateData.data.removeWhere((key, value) => value is Map<String, dynamic>);
    print(CreateData.data);
    try {
      Response response = await dio.post("/application", data: CreateData.data);
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        CreateData.data.clear();
        CreateData.images.clear();
        Navigator.pop(context, "application");
        Navigator.pop(context, "application");
        Navigator.pop(context, "application");
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } on DioException catch (e) {
      print(e.response);
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
      Response response = await dio.post("/image/application", data: formData);
      print(response.data);
      Navigator.pop(context);
      if (response.data['success']) {
        CreateData.data['images'] = response.data['data'];
        postData();
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  Future verifyContacts() async {
    showModalLoader(context);
    List data = await GetContact().getData(context);
    print(data);
    Navigator.pop(context);

    if (data.isEmpty) {
      showCupertinoModalBottomSheet(
          context: context, builder: (context) => const AddContactsPage());
    } else {
      postData();
    }
  }

  void verifyData() {
    if (imagesPath.isEmpty) {
      SnackBarComponent().showErrorMessage("Загрузите изображения", context);
    } else {
      // postImage();
      verifyContacts();
    }
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
              title: "Опубликовать"),
          const Divider(height: 4),
          Button(
              onPressed: postData,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Пропустить"),
        ],
      )),
    );
  }
}
