import 'package:flutter/material.dart';
import 'package:gservice5/component/button/back/closeIconButton.dart';
import 'package:gservice5/component/button/button.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/component/widgets/bottom/bottomNavigationBarComponent.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewLeadModal extends StatefulWidget {
  final Map data;
  const ViewLeadModal({super.key, required this.data});

  @override
  State<ViewLeadModal> createState() => _ViewLeadModalState();
}

class _ViewLeadModalState extends State<ViewLeadModal> {
  MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '+# (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 225,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text("Лид"),
          actions: [CloseIconButton(iconColor: null, padding: true)],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                maskFormatter.maskText(widget.data['phone']),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              Divider(height: 12),
              Text(widget.data['name'])
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBarComponent(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                  child: Button(
                      onPressed: () async {
                        await launchUrl(
                            Uri.parse('https://wa.me/+${widget.data['phone']}'),
                            mode: LaunchMode.externalApplication);
                      },
                      title: "Написать")),
              Divider(indent: 14),
              Expanded(
                  child: Button(
                onPressed: () async {
                  await launchUrl(
                      Uri(scheme: "tel", path: "+${widget.data['phone']}"));
                },
                title: "Позвонить",
                backgroundColor: ColorComponent.mainColor.withOpacity(.1),
              )),
            ],
          ),
        )),
      ),
    );
  }
}
