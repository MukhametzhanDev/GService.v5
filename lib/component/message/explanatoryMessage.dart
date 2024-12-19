import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExplanatoryMessage extends StatefulWidget {
  final String title;
  final String type;
  final EdgeInsets padding;
  const ExplanatoryMessage(
      {super.key,
      required this.title,
      required this.padding,
      required this.type});

  @override
  State<ExplanatoryMessage> createState() => _ExplanatoryMessageState();
}

class _ExplanatoryMessageState extends State<ExplanatoryMessage> {
  bool showMessage = true;
  bool checkCache = true;

  @override
  void initState() {
    super.initState();
    checkShowedMessageWidget();
  }

  void checkShowedMessageWidget() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(widget.type) ?? false;
    setState(() => checkCache = value);
  }

  void addShowedMessageWidget() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.type, true);
  }

  void closeMessage() {
    setState(() => showMessage = false);
    addShowedMessageWidget();
  }

  @override
  Widget build(BuildContext context) {
    return checkCache
        ? Container()
        : AnimatedSize(
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 300),
            child: !showMessage
                ? Container()
                : Padding(
                    padding: widget.padding,
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorComponent.gray['100'],
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: SvgPicture.asset(
                                        'assets/icons/infoBlue.svg')),
                                const Divider(indent: 10),
                                Expanded(
                                    child: Text(widget.title,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            height: 1.5,
                                            fontWeight: FontWeight.w500))),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: GestureDetector(
                                    onTap: () => closeMessage(),
                                    child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: SvgPicture.asset(
                                          'assets/icons/close.svg',
                                          color: ColorComponent.gray['500'],
                                        )),
                                  ),
                                )
                              ]),
                        ],
                      ),
                    ),
                  ),
          );
  }
}
