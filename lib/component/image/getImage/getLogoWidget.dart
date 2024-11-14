import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class GetLogoWidget extends StatefulWidget {
  final void Function(String path) onChanged;
  final String? imageUrl;
  const GetLogoWidget({super.key, required this.onChanged, this.imageUrl});

  @override
  State<GetLogoWidget> createState() => _GetLogoWidgetState();
}

class _GetLogoWidgetState extends State<GetLogoWidget> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  Future getImage() async {
    try {
      final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery, maxHeight: 1500, maxWidth: 1500);
      // var imageCompress = await compressImage(pickedFile);
      if (pickedFile != null) {
        showModalLoader(context);
        image = pickedFile;
        setState(() {});
        await showEditImagePath();
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == "photo_access_denied") {
        // showCupertinoModalBottomSheet(
        //   context: context,
        //   builder: (context) => GalleryDeniedModal(),
        // );
      }
    }
  }

  Future<void> showEditImagePath() async {
    Navigator.pop(context);
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: "Редактирование фото",
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            cropStyle: CropStyle.circle,
            hideBottomControls: true,
            lockAspectRatio: false),
        IOSUiSettings(
            title: "Редактирование фото",
            aspectRatioPickerButtonHidden: !false,
            cropStyle: CropStyle.circle,
            resetButtonHidden: true,
            doneButtonTitle: "Готово",
            cancelButtonTitle: "Отмена")
      ],
    );
    if (croppedFile != null) {
      print(croppedFile.path);
      setState(() {
        image = XFile(croppedFile.path);
      });
      widget.onChanged(image!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (image == null) {
          getImage();
        } else {
          showCupertinoModalBottomSheet(
              context: context, builder: (context) => OptionModal());
        }
      },
      child: Container(
        child: Row(
          children: [
            image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(image!.path,
                        width: 80, height: 80, fit: BoxFit.cover))
                : widget.imageUrl != null
                    ? CacheImage(
                        url: widget.imageUrl,
                        width: 80,
                        height: 80,
                        borderRadius: 40)
                    : SvgPicture.asset('assets/icons/getAvatar.svg'),
            Divider(indent: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      widget.imageUrl != null
                          ? "Изменить логотип компании"
                          : "Загрузить логотип компании",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorComponent.gray['500'])),
                  Divider(height: 8),
                  Text("SVG, PNG, JPG или JPEG (MAX. 800x400px)",
                      style: TextStyle(
                          fontSize: 12, color: ColorComponent.gray['500'])),
                  Divider(height: 8),
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                          color: ColorComponent.mainColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                          widget.imageUrl != null ? "Изменить" : "Загрузить",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget OptionModal() {
    return SizedBox(
        height: 320 + MediaQuery.of(context).padding.bottom,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 5,
                  decoration: BoxDecoration(
                      color: ColorComponent.gray['200'],
                      borderRadius: BorderRadius.circular(20)),
                ),
                Divider(indent: 8),
                Button(
                    onPressed: () async {
                      Navigator.pop(context);
                      await getImage();
                    },
                    title: "Выбрать другое фото"),
                Divider(indent: 8),
                Button(
                    onPressed: () {
                      showEditImagePath();
                    },
                    title: "Редактировать фото"),
                Divider(indent: 8),
                Button(
                    onPressed: () {
                      image = null;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    title: "Удалить фото"),
                Divider(indent: 8),
                Button(
                    onPressed: () => Navigator.pop(context),
                    title: "Отмена",
                    backgroundColor: Colors.white,
                    titleColor: Colors.black),
              ],
            ),
          ),
        ));
  }
}
