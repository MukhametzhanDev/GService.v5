import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

class InfoTypeAccountModal extends StatefulWidget {
  final String data;
  const InfoTypeAccountModal({super.key, required this.data});

  @override
  State<InfoTypeAccountModal> createState() => _InfoTypeAccountModalState();
}

class _InfoTypeAccountModalState extends State<InfoTypeAccountModal> {
  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   appBar: AppBar(
        //       leading: Container(),
        //       leadingWidth: 0,
        //       title: Text(widget.data['title']),
        //       actions: [CloseIconButton(iconColor: null, padding: true)]),
        //   body: SingleChildScrollView(
        //     padding: EdgeInsets.symmetric(horizontal: 16),
        //     child:

        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 1, color: ColorComponent.gray['100']),
        Divider(height: 22),
        Text("Как это работает?",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        Divider(height: 16),
        HtmlWidget(widget.data),
        Divider(height: 16),
        Text("Остались вопросы по типу кабинета?",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        Divider(height: 16),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ColorComponent.mainColor.withOpacity(.1)),
          child: Row(
            children: [
              SvgPicture.asset("assets/icons/headsetOutline.svg"),
              Divider(indent: 8),
              Text("Обратиться в поддержку GService",
                  style: TextStyle(fontWeight: FontWeight.w500))
            ],
          ),
        )
      ],
    );
    // ),
    // );
  }
}
