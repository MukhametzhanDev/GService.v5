import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:gservice5/pages/edit/editData.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:reorderables/reorderables.dart';

class GetImageWidget extends StatefulWidget {
  final Function(List<XFile>) onImagesSelected;
  const GetImageWidget({super.key, required this.onImagesSelected});

  @override
  State<GetImageWidget> createState() => _GetImageWidgetState();
}

class _GetImageWidgetState extends State<GetImageWidget> {
  List<XFile> _images = CreateData.images;
  List imagesUrl = EditData.adData['images'] ?? [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    showModalLoader(context);
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => XFile(file.path)).toList());
        widget.onImagesSelected(_images);
      });
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<void> _pickImage(ImageSource source) async {
    showModalLoader(context);
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _images.add(XFile(pickedFile.path));
      });
    }
    widget.onImagesSelected(_images);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<void> _editImage(int index) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _images[index].path,
      compressFormat: ImageCompressFormat.png,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: "Редактирование фото",
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            hideBottomControls: true,
            lockAspectRatio: false),
        IOSUiSettings(
            title: "Редактирование фото",
            aspectRatioPickerButtonHidden: !false,
            resetButtonHidden: true,
            doneButtonTitle: "Готово",
            cancelButtonTitle: "Отменить"),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _images[index] = XFile(croppedFile.path);
      });
      widget.onImagesSelected(_images);
    }
  }

  Widget GetAvatarOptionModal() {
    return SizedBox(
        height: 270 + MediaQuery.of(context).padding.bottom,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Загрузка фотографии"),
              leadingWidth: 0,
              leading: Container(),
              elevation: 0,
              centerTitle: true,
              actions: [CloseIconButton(iconColor: null, padding: true)],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(children: [
                SizedBox(height: 6),
                Button(
                    onPressed: () {
                      _pickImages();
                    },
                    title: "Выбрать с галереи"),
                SizedBox(height: 16),
                Button(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    title: "Сделать снимок",
                    backgroundColor: ColorComponent.mainColor),
                SizedBox(height: 8),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    child: Container(
                      height: 43,
                      alignment: Alignment.center,
                      child: Text("Отмена",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ))
              ]),
            )));
  }

  Widget EditImageWidget(int index) {
    return SizedBox(
        height: 270 + MediaQuery.of(context).padding.bottom,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Редактировать"),
              leadingWidth: 0,
              leading: Container(),
              elevation: 0,
              centerTitle: true,
              actions: [CloseIconButton(iconColor: null, padding: true)],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(children: [
                Button(
                    onPressed: () {
                      _editImage(index);
                      Navigator.pop(context);
                    },
                    title: "Обрезать",
                    backgroundColor: ColorComponent.mainColor),
                SizedBox(height: 16),
                Button(
                    onPressed: () {
                      Navigator.pop(context);
                      _removeImage(index);
                    },
                    title: "Удалить",
                    backgroundColor: ColorComponent.mainColor),
                SizedBox(height: 8),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    child: Container(
                      height: 43,
                      alignment: Alignment.center,
                      child: Text("Отмена",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ))
              ]),
            )));
  }

  Widget RemoveUrlImageWidget(int index) {
    return SizedBox(
        height: 180 + MediaQuery.of(context).padding.bottom,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Редактировать"),
              leadingWidth: 0,
              leading: Container(),
              elevation: 0,
              centerTitle: true,
              actions: [CloseIconButton(iconColor: null, padding: true)],
            ),
            body: Column(children: [
              SizedBox(height: 16),
              Button(
                  titleColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    removeUrlImage(index);
                  },
                  title: "Удалить",
                  backgroundColor: ColorComponent.mainColor),
              SizedBox(height: 8),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.transparent),
                  child: Container(
                    height: 43,
                    alignment: Alignment.center,
                    child: Text("Отмена",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  ))
            ])));
  }

  void removeUrlImage(int index) async {
    int id = imagesUrl[index]['id'];
    showModalLoader(context);
    try {
      Response response = await dio.delete('/image/$id');
      Navigator.pop(context);
      if (response.data['success']) {
        setState(() {
          imagesUrl.removeAt(index);
        });
      } else {
        SnackBarComponent().showErrorMessage(response.data['message'], context);
      }
    } on DioException catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final XFile movedImage = _images.removeAt(oldIndex);
      _images.insert(newIndex, movedImage);
    });
    widget.onImagesSelected(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DottedBorder(
            radius: Radius.circular(12),
            strokeWidth: 2,
            color: Color(0xffE5E7EB),
            dashPattern: [5],
            borderType: BorderType.RRect,
            child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 228,
                child: TextButton(
                    onPressed: () {
                      showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => GetAvatarOptionModal());
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    child: Column(children: [
                      SizedBox(height: 32),
                      SvgPicture.asset("assets/icons/getImage.svg"),
                      SizedBox(height: 7),
                      Text("Нажмите чтобы загрузить \nизображения",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: ColorComponent.gray['500'])),
                      SizedBox(height: 7),
                      Text("SVG, PNG, JPG или JPEG (MAX. 800x400px)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: ColorComponent.gray['500'])),
                      SizedBox(height: 16),
                      Container(
                          width: 127,
                          height: 34,
                          decoration: BoxDecoration(
                              color: ColorComponent.blue['700'],
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    "assets/icons/searchOutline.svg",
                                    color: Colors.white,
                                    width: 16,
                                    height: 16),
                                SizedBox(width: 8),
                                Text('Найти файлы',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500))
                              ]))
                    ])))),
        SizedBox(height: _images.isNotEmpty ? 12 : 16),
        if (_images.isNotEmpty) ...[
          Container(
              margin: EdgeInsets.only(bottom: 16),
              // height: 108,
              child: ReorderableWrap(
                  scrollDirection: Axis.vertical,
                  runAlignment: WrapAlignment.spaceBetween,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  onReorder: _onReorder,
                  children: List.generate(_images.length, (index) {
                    XFile imageFile = _images[index];
                    return Stack(children: [
                      TextButton(
                        onPressed: () {
                          showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => EditImageWidget(index));
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 3 - 16,
                                height:
                                    MediaQuery.of(context).size.width / 3 - 16,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.file(File(imageFile.path),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity))),
                      ),
                      Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                  "assets/icons/editDot.svg"))),
                      if (index == 0)
                        Positioned(
                            bottom: 6,
                            left: 12,
                            right: 12,
                            child: Container(
                                padding: EdgeInsets.only(left: 6, right: 6),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: ColorComponent.mainColor,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text('Обложка',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600))))
                    ]);
                  })))
        ],
        imagesUrl.isEmpty
            ? SizedBox(height: 16)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Загруженное фото",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 108,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: imagesUrl.map((value) {
                        int index = imagesUrl.indexOf(value);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextButton(
                            onPressed: () {
                              showCupertinoModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      RemoveUrlImageWidget(index));
                            },
                            child: Stack(
                              children: [
                                CacheImage(
                                    url: value['url'],
                                    width: 108,
                                    height: 108,
                                    borderRadius: 10),
                                Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(
                                            "assets/icons/editDot.svg"))),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                    ),
                  ),
                  SizedBox(height: 26),
                ],
              )
      ]),
    );
  }
}