import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/my/edit/structureEditAdPage.dart';
import 'package:gservice5/pages/ad/my/request/myAdRequest.dart';

class OptionsMyAdModal extends StatefulWidget {
  final Map<String, dynamic> data;
  final String status;
  const OptionsMyAdModal({super.key, required this.data, required this.status});

  @override
  State<OptionsMyAdModal> createState() => _OptionsMyAdModalState();
}

class _OptionsMyAdModalState extends State<OptionsMyAdModal> {
  void showUpdateAd() {
    //show update ad page
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StructureEditAdPage(data: widget.data)))
        .then((value) {
      Navigator.pop(context, value);
    });
  }

  Future removedAd() async {
    //ad removed request
    if (await MyAdRequest().deletedAd(widget.data['id'], context)) {
      Navigator.pop(context, "update");
    }
  }

  Future archivedAd() async {
    //ad archived request
    if (await MyAdRequest().archivedAd(widget.data['id'], context)) {
      Navigator.pop(context, "update");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0 + MediaQuery.of(context).padding.bottom,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Опции"),
          leading: Container(),
          leadingWidth: 0,
          actions: [
            CloseIconButton(
                iconColor: ColorComponent.gray['400'], padding: true)
          ],
          elevation: 0,
        ),
        body: widget.status == "deleted"
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Button(
                      onPressed: removedAd,
                      title: "Восстановить",
                      backgroundColor: ColorComponent.mainColor,
                      titleColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 15)),
                  SizedBox(height: 12),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Отмена",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16))),
                ],
              )
            : Column(
                children: [
                  SizedBox(height: 8),
                  Button(
                      onPressed: showUpdateAd,
                      title: "Редактировать",
                      padding: EdgeInsets.symmetric(horizontal: 15)),
                  SizedBox(height: 12),
                  Button(
                      onPressed: archivedAd,
                      title: "В архив",
                      padding: EdgeInsets.symmetric(horizontal: 15)),
                  SizedBox(height: 12),
                  Button(
                      onPressed: removedAd,
                      title: "Удалить",
                      padding: EdgeInsets.symmetric(horizontal: 15)),
                  SizedBox(height: 12),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Отмена",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16))),
                  SizedBox(height: 12),
                ],
              ),
      ),
    );
  }
}
