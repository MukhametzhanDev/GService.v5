import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/denied/galleryDeniedModal.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/create/data/createData.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:reorderables/reorderables.dart';

class GetImageWidget extends StatefulWidget {
  final Function(List<XFile>) onImagesSelected;
  final String? fromPage;
  const GetImageWidget(
      {super.key, required this.onImagesSelected, this.fromPage});

  @override
  State<GetImageWidget> createState() => _GetImageWidgetState();
}

class _GetImageWidgetState extends State<GetImageWidget> {
  final List<XFile> _images = CreateData.images;
  List imagesUrl = EditData.data['images'] ?? [];
  final ImagePicker _picker = ImagePicker();

  final analytics = FirebaseAnalytics.instance;

  Future<void> _pickImages() async {
    try {
      showModalLoader(context);
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
          imageQuality: 80, maxHeight: 1024, maxWidth: 1024);
      if (pickedFiles.isNotEmpty) {
        print(pickedFiles.first.path);
        setState(() {
          _images.addAll(pickedFiles.map((file) => XFile(file.path)).toList());
          widget.onImagesSelected(_images);
        });
      }
      Navigator.pop(context);
      Navigator.pop(context);
    } on PlatformException catch (e) {
      if (e.code == "photo_access_denied") {
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => const GalleryDeniedModal(),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      showModalLoader(context);
      final XFile? pickedFile = await _picker.pickImage(
          source: source, imageQuality: 80, maxHeight: 1024, maxWidth: 1024);
      print(pickedFile!.path);
      setState(() {
        _images.add(XFile(pickedFile.path));
      });
      widget.onImagesSelected(_images);
      Navigator.pop(context);
      Navigator.pop(context);
    } on PlatformException catch (e) {
      if (e.code == "photo_access_denied") {
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => const GalleryDeniedModal(),
        );
      }
    }
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
                    onPressed: () {
                      _pickImages();

                      analytics
                          .logEvent(name: GAEventName.buttonClick, parameters: {
                        GAKey.buttonName: GAParams.btnSelectGalery,
                        GAKey.screenName: widget.fromPage ?? ''
                      }).catchError((e) {
                        if (kDebugMode) {
                          debugPrint(e);
                        }
                      });
                    },
                    title: "Выбрать с галереи"),
                const SizedBox(height: 16),
                Button(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                      analytics
                          .logEvent(name: GAEventName.buttonClick, parameters: {
                        GAKey.buttonName: GAParams.btnSelectCamera,
                        GAKey.screenName: widget.fromPage ?? ''
                      }).catchError((e) {
                        if (kDebugMode) {
                          debugPrint(e);
                        }
                      });
                    },
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

  Widget EditImageWidget(int index) {
    return SizedBox(
        height: 270 + MediaQuery.of(context).padding.bottom,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Редактировать"),
              leadingWidth: 0,
              leading: Container(),
              elevation: 0,
              centerTitle: true,
              actions: const [CloseIconButton(iconColor: null, padding: true)],
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
                const SizedBox(height: 16),
                Button(
                    onPressed: () {
                      Navigator.pop(context);
                      _removeImage(index);
                    },
                    title: "Удалить",
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

  Widget RemoveUrlImageWidget(int index) {
    return SizedBox(
        height: 180 + MediaQuery.of(context).padding.bottom,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Редактировать"),
              leadingWidth: 0,
              leading: Container(),
              elevation: 0,
              centerTitle: true,
              actions: const [CloseIconButton(iconColor: null, padding: true)],
            ),
            body: Column(children: [
              const SizedBox(height: 16),
              Button(
                  titleColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    removeUrlImage(index);
                  },
                  title: "Удалить",
                  backgroundColor: ColorComponent.mainColor),
              const SizedBox(height: 8),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.transparent),
                  child: Container(
                    height: 43,
                    alignment: Alignment.center,
                    child: const Text("Отмена",
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
    } on DioException {
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
            radius: const Radius.circular(12),
            strokeWidth: 2,
            color: const Color(0xffE5E7EB),
            dashPattern: const [5],
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

                      analytics.logEvent(
                          name: GAEventName.buttonClick,
                          parameters: {
                            GAKey.screenName: widget.fromPage ?? '',
                            GAKey.buttonName: GAParams.btnCreateImg
                          }).catchError((e) {
                        if (kDebugMode) {
                          debugPrint(e);
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    child: Column(children: [
                      const SizedBox(height: 32),
                      SvgPicture.asset("assets/icons/getImage.svg"),
                      const SizedBox(height: 7),
                      Text("Нажмите чтобы загрузить \nизображения",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: ColorComponent.gray['500'])),
                      const SizedBox(height: 7),
                      Text("SVG, PNG, JPG или JPEG (MAX. 800x400px)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: ColorComponent.gray['500'])),
                      const SizedBox(height: 16),
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
                                const SizedBox(width: 8),
                                const Text('Найти файлы',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500))
                              ]))
                    ])))),
        SizedBox(height: _images.isNotEmpty ? 12 : 16),
        if (_images.isNotEmpty) ...[
          Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                              decoration: const BoxDecoration(
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
                                padding:
                                    const EdgeInsets.only(left: 6, right: 6),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: ColorComponent.mainColor,
                                    borderRadius: BorderRadius.circular(4)),
                                child: const Text('Обложка',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600))))
                    ]);
                  })))
        ],
        imagesUrl.isEmpty
            ? const SizedBox(height: 16)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Загруженное фото",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
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
                                        decoration: const BoxDecoration(
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
                  const SizedBox(height: 26),
                ],
              )
      ]),
    );
  }
}
