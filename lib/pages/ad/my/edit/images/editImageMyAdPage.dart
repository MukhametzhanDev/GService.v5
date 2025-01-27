import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/backTitleButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/image/getImage/getImage.dart';
import 'package:gservice5/component/image/getImage/getImageSectionModal.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/pages/ad/my/edit/images/removeImageAlert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditImageMyAdPage extends StatefulWidget {
  final Map data;
  const EditImageMyAdPage({super.key, required this.data});

  @override
  State<EditImageMyAdPage> createState() => _EditImageMyAdPageState();
}

class _EditImageMyAdPageState extends State<EditImageMyAdPage> {
  List data = [];
  List imagesUrl = [];
  List removedImageIds = [];
  List<XFile> imagesPath = [];

  @override
  void initState() {
    formattedImages();
    super.initState();
  }

  void formattedImages() {
    List imagesUrl = widget.data['images'];
    for (var value in imagesUrl) {
      data.add({"type": "url", ...value});
    }
  }

  void getImagePath(List<XFile> value) {
    for (var element in value) {
      data.add({"path": element.path, "type": "path"});
      imagesPath.add(element);
    }
    setState(() {});
  }

  void removeImage(Map value) {
    print(value);
    data.remove(value);
    imagesUrl.remove(value);
    removedImageIds.add(value['id']);
    if (value['type'] == "path") imagesPath.remove(value);
    setState(() {});
  }

  void postImage() async {
    print(removedImageIds);
    List values = await GetImage().postImage(imagesPath, context);
    await GetImage().removedImage(removedImageIds, context);
    updateAd(values + imagesUrl);
  }

  void updateAd(List values) async {
    try {
      Response response = await dio.put("/store-ad-image/${widget.data['id']}",
          data: {"images": values});
      print(response.data);
    } catch (e) {
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width / 3 - 17;
    return Scaffold(
      appBar: AppBar(
          leading: const BackTitleButton(title: "Редактировать фото"),
          leadingWidth: 250),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Wrap(
            runSpacing: 10,
            spacing: 10,
            children: data.map((value) {
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => RemoveImageAlert(
                              removeImage: () => removeImage(value)));
                    },
                    child: value['type'] == "url"
                        ? CacheImage(
                            url: value['url'],
                            width: imageWidth,
                            height: imageWidth,
                            borderRadius: 10)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(value['path'],
                                fit: BoxFit.cover,
                                width: imageWidth,
                                height: imageWidth),
                          ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6)),
                              color: ColorComponent.red['100']),
                          padding:
                              const EdgeInsets.only(top: 3, left: 3, bottom: 3),
                          child: SvgPicture.asset("assets/icons/trash.svg",
                              width: 18))),
                ],
              );
            }).toList()),
      ),
      bottomNavigationBar: BottomNavigationBarComponent(
          child: Column(
        children: [
          Button(
              onPressed: () {
                showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        GetImageSectionModal(pickImage: getImagePath));
              },
              title: "Загрузить фото",
              backgroundColor: ColorComponent.mainColor.withOpacity(.2),
              padding: const EdgeInsets.symmetric(horizontal: 15)),
          const Divider(height: 10),
          Button(
              onPressed: postImage,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              title: "Редактировать")
        ],
      )),
    );
  }
}
