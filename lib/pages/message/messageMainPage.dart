import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gservice5/component/image/cacheImage.dart';
import 'package:gservice5/component/theme/colorComponent.dart';

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

  final List _tabs = ["Все", "Новые"];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 4,
            bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 44),
                child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorWeight: 2,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.black,
                    unselectedLabelColor: ColorComponent.gray['500'],
                    tabs: _tabs.map((value) {
                      return Tab(
                        child: Row(
                          children: [
                            Text(value),
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      ColorComponent.mainColor.withOpacity(.1)),
                              child: const Text(
                                "99",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList()))),
        body: TabBarView(
            children: _tabs.map((value) {
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffeeeeee)))),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: const CacheImage(
                      url:
                          "https://plus.unsplash.com/premium_photo-1664301163726-78773dc77bfd?q=80&w=3174&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      width: 48,
                      height: 48,
                      borderRadius: 24),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text("agrokz.com",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          SvgPicture.asset('assets/icons/badgeCheck.svg')
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text("Добро пожаловать!",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ColorComponent.gray['500']),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "сегодня",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorComponent.gray['500']),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(left: 10, bottom: 10),
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
                ),
              );
            },
          );
        }).toList()),
      ),
    );
  }
}
