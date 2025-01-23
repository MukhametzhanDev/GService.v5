import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gservice5/component/denied/galleryDeniedModal.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final ImagePicker _picker = ImagePicker();
XFile? image;

class GetImage {
  Future<List<XFile>> pickImage(ImageSource source, BuildContext context) async {
    List<XFile> images = [];
    try {
      showModalLoader(context);
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
          imageQuality: 80, maxHeight: 1024, maxWidth: 1024);
      if (pickedFiles.isNotEmpty) {
        images.addAll(pickedFiles.map((file) => XFile(file.path)).toList());
      }
      Navigator.pop(context);
    } on PlatformException catch (e) {
      Navigator.pop(context);
      if (e.code == "photo_access_denied") {
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => const GalleryDeniedModal(),
        );
      }
    } finally {
      return images;
    }
  }

  Future postImage(List<XFile> imagesPath, BuildContext context) async {
    showModalImageLoader(context);
    List values = [];
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
        values = response.data['data'];
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    } finally {
      return values;
    }
  }
}
