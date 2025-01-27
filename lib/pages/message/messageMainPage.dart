import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/theme/colorComponent.dart';
import 'package:gservice5/pages/message/settingsMessagePage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MessageMainPage extends StatefulWidget {
  const MessageMainPage({super.key});

  @override
  State<MessageMainPage> createState() => _MessageMainPageState();
}

class _MessageMainPageState extends State<MessageMainPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // getData();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    // refreshController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) checkNotificationPermission();
  }

  Future<void> checkNotificationPermission() async {
    // NotificationSettings settings =
    //     await FirebaseMessaging.instance.getNotificationSettings();

    // notificationPermission =
    //     settings.authorizationStatus == AuthorizationStatus.authorized;
    // setState(() {});
  }

  void showSettingsMessagePage() {
    showCupertinoModalBottomSheet(
        context: context, builder: (context) => const SettingsMessagePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text("Сообщения"), actions: [
        GestureDetector(
          onTap: showSettingsMessagePage,
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorComponent.mainColor.withOpacity(.2)),
            child: SvgPicture.asset("assets/icons/cogOutline.svg",
                color: Colors.black),
          ),
        )
      ]),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: Color.fromRGBO(238, 238, 238, 1)))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: SvgPicture.asset("assets/icons/logoOutline.svg",
                        color: ColorComponent.mainColor),
                  ),
                  const Divider(indent: 20),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("GService.kz",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const Divider(height: 6),
                      Text("Добро пожаловать!",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ColorComponent.gray['500']),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("сегодня",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: ColorComponent.gray['500'])),
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(left: 10, top: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ColorComponent.red['500']),
                        child: const Text(
                          "99",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              )

              // ListTile(
              //   contentPadding:
              //       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              //   leading: SvgPicture.asset(
              //     "assets/icons/logoOutline.svg",
              //     color: ColorComponent.mainColor,
              //   ),
              //   title: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           const Text("agrokz.com",
              //               style: TextStyle(
              //                   fontSize: 16, fontWeight: FontWeight.w600)),
              //           const SizedBox(width: 8),
              //           SvgPicture.asset('assets/icons/badgeCheck.svg')
              //         ],
              //       ),
              //       const SizedBox(height: 6),
              //       Text("Добро пожаловать!",
              //           style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w400,
              //               color: ColorComponent.gray['500']),
              //           maxLines: 1,
              //           overflow: TextOverflow.ellipsis),
              //     ],
              //   ),
              //   trailing: Column(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "сегодня",
              //         style: TextStyle(
              //             fontSize: 12,
              //             fontWeight: FontWeight.w400,
              //             color: ColorComponent.gray['500']),
              //       ),
              //       Container(
              //         width: 20,
              //         height: 20,
              //         margin: const EdgeInsets.only(left: 10, bottom: 10),
              //         alignment: Alignment.center,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(20),
              //             color: ColorComponent.red['500']),
              //         child: const Text(
              //           "99",
              //           style: TextStyle(
              //               fontSize: 12,
              //               fontWeight: FontWeight.w500,
              //               color: Colors.white),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              );
        },
      ),
    );
  }
}
