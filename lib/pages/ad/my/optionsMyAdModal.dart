import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/ad/my/edit/editMyAdModal.dart';
import 'package:gservice5/pages/ad/my/request/myAdRequest.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

class OptionsMyAdModal extends StatefulWidget {
  final Map<String, dynamic> data;
  final String status;
  const OptionsMyAdModal({super.key, required this.data, required this.status});

  @override
  State<OptionsMyAdModal> createState() => _OptionsMyAdModalState();
}

class _OptionsMyAdModalState extends State<OptionsMyAdModal> {
  String warningPackageType = "";

  void showUpdateAd() {
    //show update ad page
    Navigator.pop(context);
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => EditMyAdModal(data: widget.data));
  }

  void verifyPackage(String type) {
    List adPromotions = widget.data['ad_promotions'];
    if (adPromotions.isNotEmpty) {
      warningPackageType = type;
      setState(() {});
    } else {
      if (type == "delete") {
        removedAd();
      } else {
        archivedAd();
      }
    }
  }

  Future removedAd() async {
    // print("DATA ___>${widget.data}");
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
          title:
              Text(warningPackageType.isNotEmpty ? "Предупреждение" : "Опции"),
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
                      padding: const EdgeInsets.symmetric(horizontal: 15)),
                  const SizedBox(height: 12),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(context.localizations.cancel,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16))),
                ],
              )
            : warningPackageType.isNotEmpty
                ? WarningWidget()
                : Column(
                    children: [
                      const SizedBox(height: 8),
                      Button(
                          onPressed: showUpdateAd,
                          title: "Редактировать",
                          padding: const EdgeInsets.symmetric(horizontal: 15)),
                      const SizedBox(height: 12),
                      Button(
                          onPressed: () => verifyPackage("archive"),
                          title: "В архив",
                          padding: const EdgeInsets.symmetric(horizontal: 15)),
                      const SizedBox(height: 12),
                      Button(
                          onPressed: () => verifyPackage("delete"),
                          title: "Удалить",
                          padding: const EdgeInsets.symmetric(horizontal: 15)),
                      const SizedBox(height: 12),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(context.localizations.cancel,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14))),
                      const SizedBox(height: 12),
                    ],
                  ),
      ),
    );
  }

  Widget WarningWidget() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // Text("Предупреждение",
      //     style: TextStyle(
      //         fontSize: 17, fontWeight: FontWeight.w700)),
      // Divider(height: 10),
      const Divider(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          warningPackageType == "delete"
              ? "При удалении объявления все платные услуги, такие как пакеты поднятия и стикеры, будут потеряны и не подлежат возврату."
              : "При архивировании объявления срок действия пакетов продолжает сокращаться.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, height: 1.5),
        ),
      ),
      const Divider(height: 10),
      Column(
        children: [
          warningPackageType == "delete"
              ? Button(
                  onPressed: removedAd,
                  title: "Удалить",
                  padding: const EdgeInsets.symmetric(horizontal: 15))
              : Button(
                  onPressed: archivedAd,
                  title: "В архив",
                  padding: const EdgeInsets.symmetric(horizontal: 15)),
          const SizedBox(height: 12),
          TextButton(
              onPressed: () {
                warningPackageType = "";
                setState(() {});
              },
              child:  Text(context.localizations.cancel,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        ],
      ),
      const SizedBox(height: 24),
    ]);
  }
}
