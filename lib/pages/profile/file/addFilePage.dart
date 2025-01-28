import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/loader/modalLoaderComponent.dart';
import 'package:gservice5/component/snackBar/snackBarComponent.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class AddFilePage extends StatefulWidget {
  const AddFilePage({super.key});

  @override
  State<AddFilePage> createState() => _AddFilePageState();
}

class _AddFilePageState extends State<AddFilePage> {
  TextEditingController textEditingController = TextEditingController();
  String? fileName;
  String? filePath;
  String? fileSize;
  bool isFileUploaded = false;

  Future<void> pickFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles();
    if (file != null) {
      PlatformFile pickedFile = file.files.first;
      setState(() {
        fileName = textEditingController.text;
        filePath = pickedFile.path;
        fileSize = '${(pickedFile.size / (1024 * 1024)).toStringAsFixed(2)} MB';
        isFileUploaded = true;
      });
      print(fileSize);
    }
  }

  Future postData() async {
    // if (filePath != null && fileName != null && fileSize != null) {
    //   final fileData = {
    //     "title": fileName!,
    //     "path": filePath!,
    //     "size": fileSize!,
    //     "type": filePath!.split('.').last.toUpperCase(),
    //   };
    //   Navigator.pop(context, fileData);
    // }
    showModalLoader(context);
    FormData formData = FormData.fromMap({
      "file[]": [
        await MultipartFile.fromFile(filePath!,
            filename: filePath!.split('/').last)
      ]
    });
    try {
      Response response = await dio.post("/file/store", data: formData);
      print(response.data);
      print(response.statusCode);
      if (response.statusCode == 200 && response.data['success']) {
        SnackBarComponent()
            .showDoneMessage("Документ успешно загружен", context);
        Navigator.pop(context);
      } else {
        SnackBarComponent().showResponseErrorMessage(response, context);
      }
      Navigator.pop(context);
    } catch (e) {
      // print(e)
      SnackBarComponent().showServerErrorMessage(context);
    }
  }

  void deleteFile() {
    setState(() {
      fileName = null;
      filePath = null;
      isFileUploaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text("Добавить документ"),
          actions: [
            CloseIconButton(
                iconColor: ColorComponent.gray['400'], padding: true)
          ]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Заголовок",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const Divider(height: 8),
              SizedBox(
                height: 48,
                child: TextField(
                  autofocus: true,
                  enabled: !isFileUploaded,
                  style: const TextStyle(fontSize: 14, height: 1.1),
                  controller: textEditingController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration:
                      const InputDecoration(hintText: "Введите заголовок"),
                ),
              ),
              const Divider(height: 16),
              if (!isFileUploaded && textEditingController.text.isNotEmpty)
                GestureDetector(
                  onTap: pickFile,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                    width: 148,
                    height: 34,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorComponent.blue['700']),
                    child: Row(children: [
                      SvgPicture.asset("assets/icons/downloadFile.svg"),
                      const SizedBox(width: 8),
                      Text(context.localizations.upload_file,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white))
                    ]),
                  ),
                ),
              const Divider(height: 12),
              if (isFileUploaded && fileName != null)
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      SvgPicture.asset("assets/icons/fileCard.svg"),
                      const Divider(indent: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(fileName!,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            Text(
                                "$fileSize, ${filePath!.split('.').last.toUpperCase()}",
                                style: TextStyle(
                                    color: ColorComponent.gray['500']))
                          ])),
                      GestureDetector(
                          onTap: deleteFile,
                          child:
                              SvgPicture.asset("assets/icons/deleteBadge.svg"))
                    ])),
            ],
          )),
      bottomNavigationBar: BottomNavigationBarComponent(
        child: Button(
            onPressed: postData,
            backgroundColor: ColorComponent.mainColor,
            titleColor: Colors.black,
            icon: null,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            widthIcon: null,
            title: context.localizations.save),
      ),
    );
  }
}
