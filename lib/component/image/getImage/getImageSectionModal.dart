import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/image/getImage/getImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:image_picker/image_picker.dart';

class GetImageSectionModal extends StatefulWidget {
  final void Function(List<XFile> images) pickImage;
  const GetImageSectionModal({super.key, required this.pickImage});

  @override
  State<GetImageSectionModal> createState() => _GetImageSectionModalState();
}

class _GetImageSectionModalState extends State<GetImageSectionModal> {
  void getImageGallery() async {
    List<XFile> images = await GetImage().pickImage(ImageSource.gallery, context);
    if (images.isNotEmpty) Navigator.pop(context);
    widget.pickImage(images);
  }

  void getImageCamera() async {
    List<XFile> images = await GetImage().pickImage(ImageSource.camera, context);
    if (images.isNotEmpty) Navigator.pop(context);
    widget.pickImage(images);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 270 + MediaQuery.of(context).padding.bottom,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Загрузка фотографии"),
              leadingWidth: 0,
              leading: Container(),
              elevation: 0,
              centerTitle: true,
              actions: const [CloseIconButton(iconColor: null, padding: true)],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(children: [
                const SizedBox(height: 6),
                Button(
                    onPressed: () => getImageGallery(),
                    title: "Выбрать с галереи"),
                const SizedBox(height: 16),
                Button(
                    onPressed: () => getImageCamera(),
                    title: "Сделать снимок",
                    backgroundColor: ColorComponent.mainColor),
                const SizedBox(height: 8),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    child: Container(
                      height: 43,
                      alignment: Alignment.center,
                      child: const Text("Отмена",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ))
              ]),
            )));
  }
}
