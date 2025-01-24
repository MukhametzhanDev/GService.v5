import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/darkThemeProvider.dart';
import 'package:gservice5/component/theme/styles.dart';
import 'package:gservice5/navigation/routes/app_router.dart';
import 'package:gservice5/navigation/routes/app_router.gr.dart';
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
                navigatorObservers: () => [AutoRouteObserver()],
                deepLinkBuilder: (link) {
                  String path = link.uri.path;
                  List pathSegments = link.uri.pathSegments;
                  if (link.path.contains('product')) {
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
                  // List<String> pathSegments = link.uri.pathSegments;
                  // // if (context.router.stack.length <= 1) {
                  // switch (pathSegments.first) {
                  //   case 'ad':
                  //     return DeepLink(
                  //         [ViewAdRoute(id: int.parse(pathSegments.last))]);
                  //   case 'application':
                  //     return DeepLink([
                  //       ViewApplicationRoute(id: int.parse(pathSegments.last))
                  //     ]);
                  //   case 'news':
                  //     return DeepLink(
                  //         [ViewNewsRoute(id: int.parse(pathSegments.last))]);
                  //   case 'business':
                  //     return DeepLink([
                  //       ViewBusinessRoute(id: int.parse(pathSegments.last))
                  //     ]);
                  //   case 'raffle':
                  //     return const DeepLink([ViewRaffleRoute()]);
                  //   default:
                  //     return DeepLink.defaultPath;
                  // }
                  // } else {
                  //   return DeepLink([SplashRoute(path: path)]);
                  // }
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
