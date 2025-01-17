import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/bar/bottomBar/bottomNavigationWidget.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/counter/counterClickStatistic.dart';
import 'package:gservice5/component/message/explanatoryMessage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactBottomBarWidget extends StatefulWidget {
  final bool hasAd;
  final int id;
  final List phones;
  const ContactBottomBarWidget(
      {super.key, required this.hasAd, required this.id, required this.phones});

  @override
  State<ContactBottomBarWidget> createState() => _ContactBottomBarWidgetState();
}

class _ContactBottomBarWidgetState extends State<ContactBottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarWidget(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
              child: Button(
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          WhatsAppListModal(phones: widget.phones),
                    );
                  },
                  widthIcon: 20,
                  icon: "chat.svg",
                  title: "Написать")),
          const Divider(indent: 16),
          Expanded(
              child: Button(
            onPressed: () {
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => ContactstListModal(
                    phones: widget.phones, id: widget.id, hasAd: widget.hasAd),
              );
            },
            icon: "phone.svg",
            title: "Позвонить",
            widthIcon: 20,
            backgroundColor: ColorComponent.mainColor.withOpacity(.1),
          ))
        ],
      ),
    ));
  }
}

class ContactstListModal extends StatefulWidget {
  final List phones;
  final int id;
  final bool hasAd;
  const ContactstListModal(
      {super.key, required this.phones, required this.id, required this.hasAd});

  @override
  State<ContactstListModal> createState() => _ContactstListModalState();
}

class _ContactstListModalState extends State<ContactstListModal> {
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  void showCall(String phone) async {
    await getCountClick(widget.id, "call", widget.hasAd);
    await launchUrl(Uri(scheme: "tel", path: "+$phone"));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              title: const Text("Контакты"),
              actions: const [CloseIconButton(iconColor: null, padding: true)]),
          const ExplanatoryMessage(
              title:
                  "Будьте осторожны при переводе средств, мы не гарантирует безопасность от мошенничества",
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              type: "warning_contact"),
          Column(
              children: widget.phones.map((value) {
            return Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: ColorComponent.gray['100']!))),
              child: ListTile(
                  onTap: () => showCall(value),
                  leading: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: ColorComponent.mainColor),
                    child:
                        SvgPicture.asset("assets/icons/phone.svg", width: 18),
                  ),
                  title: Text(maskFormatter.maskText(value))),
            );
          }).toList()),
          Divider(height: MediaQuery.of(context).padding.bottom + 15)
        ]),
      ),
    );
  }
}

class WhatsAppListModal extends StatefulWidget {
  final List phones;
  const WhatsAppListModal({super.key, required this.phones});

  @override
  State<WhatsAppListModal> createState() => _WhatsAppListModalState();
}

class _WhatsAppListModalState extends State<WhatsAppListModal> {
  void showWhatsApp(String phone) async {
    await launchUrl(Uri.parse('https://wa.me/+$phone'),
        mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              title: const Text("WhatsApp"),
              actions: const [CloseIconButton(iconColor: null, padding: true)]),
          const ExplanatoryMessage(
              title:
                  "Будьте осторожны при переводе средств, наше приложение не гарантирует безопасность от мошенничества",
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              type: "warning_whatsapp"),
          Column(
              children: widget.phones.map((value) {
            return Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: ColorComponent.gray['100']!))),
              child: ListTile(
                  onTap: () => showWhatsApp(value),
                  leading:
                      SvgPicture.asset("assets/icons/whatsapp.svg", width: 30),
                  // Container(
                  //   width: 30,
                  //   height: 30,
                  //   alignment: Alignment.center,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15),
                  //       color: Color(0xff25D366)),
                  //   child: SvgPicture.asset("assets/icons/phone.svg",
                  //       width: 18, color: Colors.white),
                  // ),
                  title: Text("+$value")),
            );
          }).toList()),
          Divider(height: MediaQuery.of(context).padding.bottom + 15)
        ]),
      ),
    );
  }
}
