import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/localization/extensions/context_extension.dart';

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
        const Divider(height: 22),
        const Text("Как это работает?",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        const Divider(height: 16),
        // Stepper(
        //     controlsBuilder: (context, controller) => Container(),
        //     margin: EdgeInsets.zero,
        //     stepIconBuilder: (stepIndex, stepState) {
        //       return Container(
        //           width: 30,
        //           height: 30,
        //           alignment: Alignment.center,
        //           child: Text(
        //             stepIndex.toString(),
        //             style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        //           ));
        //     },
        //     connectorColor: WidgetStatePropertyAll(ColorComponent.mainColor),
        //     physics: ClampingScrollPhysics(),
        //     stepIconMargin: EdgeInsets.zero,
        //     currentStep: 2,
        //     steps: [
        //       Step(title: Text("adfasdfasdf"), content: Container()),
        //       Step(title: Text("adfasdfasdf"), content: Container()),
        //       Step(title: Text("adfasdfasdf"), content: Container())
        //     ]),
        HtmlWidget(widget.data),
        const Divider(height: 16),
        const Text("Остались вопросы по типу кабинета?",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        const Divider(height: 16),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ColorComponent.mainColor.withOpacity(.1)),
          child: Row(
            children: [
              SvgPicture.asset("assets/icons/headsetOutline.svg"),
              const Divider(indent: 8),
               Text(context.localizations.contact_gservice_support,
                  style: const TextStyle(fontWeight: FontWeight.w500))
            ],
          ),
        )
      ],
    );
    // ),
    // );
  }
}
