import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/dio/dio.dart';
import 'package:gservice5/component/theme/darkThemeProvider.dart';
import 'package:gservice5/component/theme/styles.dart';
import 'package:gservice5/navigation/routes/app_router.dart';
import 'package:gservice5/navigation/routes/app_router.gr.dart';
import 'package:gservice5/navigation/business/businessBottomTab.dart';
import 'package:gservice5/notification/PushNoficationManager.dart';
import 'package:gservice5/pages/auth/registration/business/registrationBusinessPage.dart';
import 'package:gservice5/pages/companies/companiesMainPage.dart';
import 'package:gservice5/pages/payment/transaction/transactionHistoryPage.dart';
import 'package:gservice5/navigation/customer/customerBottomTab.dart';
import 'package:gservice5/pages/ad/my/myAdListPage.dart';
import 'package:gservice5/pages/application/list/customer/applicationListPage.dart';
import 'package:gservice5/pages/application/my/myApplicationListPage.dart';
import 'package:gservice5/pages/auth/accountType/getAccountTypePage.dart';
import 'package:gservice5/pages/auth/password/customer/resetCustomerPasswordPage.dart';
import 'package:gservice5/pages/create/ad/sectionCreateAdPage.dart';
import 'package:gservice5/pages/create/application/createApplication.dart';
import 'package:gservice5/pages/profile/contacts/addContactsPage.dart';
import 'package:gservice5/pages/profile/customer/customerProfilePage.dart';
import 'package:gservice5/pages/profile/news/allNewsPage.dart';
import 'package:gservice5/pages/profile/wallet/replenishment/replenishmentWalletPage.dart';
import 'package:gservice5/pages/splash/splashScreen.dart';
import 'package:gservice5/provider/adFavoriteProvider.dart';
import 'package:gservice5/provider/adFilterProvider.dart';
import 'package:gservice5/provider/applicationFavoriteProvider.dart';
import 'package:gservice5/provider/myAdFilterProvider.dart';
import 'package:gservice5/provider/nameCompanyProvider.dart';
import 'package:gservice5/provider/statusMyAdCountProvider.dart';
import 'package:gservice5/provider/walletAmountProvider.dart';
import 'package:provider/provider.dart';

class Index extends StatefulWidget {
  const Index({super.key, required this.appRouter});
  final AppRouter appRouter;

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  final pushManager = PushNotificationManager();

  final analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    pushManager.init();
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'news') {}
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => themeChangeProvider),
          ChangeNotifierProvider(create: (_) => WalletAmountProvider()),
          ChangeNotifierProvider(create: (_) => StatusMyAdCountProvider()),
          ChangeNotifierProvider(create: (_) => MyAdFilterProvider()),
          ChangeNotifierProvider(create: (_) => AdFilterProvider()),
          ChangeNotifierProvider(create: (_) => NameCompanyProvider()),
          ChangeNotifierProvider(create: (_) => AdFavoriteProvider()),
          ChangeNotifierProvider(create: (_) => ApplicationFavoriteProvider()),
        ],
        child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, child) {
          // debugInvertOversizedImages = true;
          return MaterialApp.router(
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            debugShowCheckedModeBanner: false,
            routerConfig: widget.appRouter.config(
                // navigatorObservers: () => [AutoRouteObserver()],
                navigatorObservers: () => [
                      AutoRouteObserver(),
                      FirebaseAnalyticsObserver(analytics: analytics)
                    ],
                deepLinkBuilder: (link) {
                  List pathSegments = link.uri.pathSegments;
                  if (link.path.contains('ad')) {
                    int id = int.parse(pathSegments.last);
                    return DeepLink([ViewAdRoute(id: id)]);
                  } else if (link.path.contains('application')) {
                    int id = int.parse(pathSegments.last);
                    return DeepLink([ViewApplicationRoute(id: id)]);
                  } else if (link.path.contains('news')) {
                    int id = int.parse(pathSegments.last);
                    return DeepLink([ViewNewsRoute(id: id)]);
                  } else if (link.path.contains('business')) {
                    int id = int.parse(pathSegments.last);
                    return DeepLink([ViewBusinessRoute(id: id)]);
                  } else if (link.path.contains('raffle')) {
                    return const DeepLink([ViewRaffleRoute()]);
                  } else {
                    return DeepLink.defaultPath;
                  }
                }),
            // home: const CustomerBottomTab(),
            // initialRoute: "SplashScreen",
            // routes: {
            //   "BusinessBottomTab": (context) => const BusinessBottomTab(),
            //   "SplashScreen": (context) => const SplashScreen(),
            //   "ReplenishmentWalletPage": (context) =>
            //       const ReplenishmentWalletPage(),
            //   "TransactionHistoryPage": (context) =>
            //       const TransactionHistoryPage(),
            //   "MyAdListPage": (context) => const MyAdListPage(),
            //   "MyApplicationListPage": (context) =>
            //       const MyApplicationListPage(),
            //   "SectionCreateAdPage": (context) => const SectionCreateAdPage(),
            //   "GetAccountTypePage": (context) => const GetAccountTypePage(),
            //   "ResetCustomerPasswordPage": (context) =>
            //       const ResetCustomerPasswordPage(),
            //   "CreateApplication": (context) => const CreateApplication(),
            //   "ApplicationListPage": (context) => const ApplicationListPage(),
            //   "AllNewsPage": (context) => const AllNewsPage(),
            //   "AddContactsPage": (context) => const AddContactsPage(),
            //   "CompaniesMainPage": (context) => const CompaniesMainPage(),
            //   "RegistrationBusinessPage": (context) =>
            //       const RegistrationBusinessPage(),
            //   "CustomerProfilePage": (context) => const CustomerProfilePage(),
            // },
          );
        }));
  }
}
