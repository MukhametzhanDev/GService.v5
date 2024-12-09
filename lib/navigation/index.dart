import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/darkThemeProvider.dart';
import 'package:gservice5/component/theme/styles.dart';
import 'package:gservice5/component/wallet/transaction/transactionHistoryPage.dart';
import 'package:gservice5/navigation/individual/individualBottomTab.dart';
import 'package:gservice5/pages/ad/list/adListPage.dart';
import 'package:gservice5/pages/ad/my/myAdListPage.dart';
import 'package:gservice5/pages/application/applicationListPage.dart';
import 'package:gservice5/pages/auth/accountType/getAccountTypePage.dart';
import 'package:gservice5/pages/auth/password/individual/resetIndividualPasswordPage.dart';
import 'package:gservice5/pages/auth/registration/business/contractor/getActivityContractorPage.dart';
import 'package:gservice5/pages/create/ad/sectionCreateAdPage.dart';
import 'package:gservice5/pages/create/application/createApplication.dart';
import 'package:gservice5/pages/create/structure/controllerPage/pageControllerIndexedStack.dart';
import 'package:gservice5/pages/profile/news/allNewsPage.dart';
import 'package:gservice5/pages/profile/wallet/replenishment/replenishmentWalletPage.dart';
import 'package:gservice5/pages/splash/splashScreen.dart';
import 'package:provider/provider.dart';

class Index extends StatefulWidget {
  const Index({super.key});

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
        ],
        child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, child) {
          // debugInvertOversizedImages = true;
          return MaterialApp(
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            debugShowCheckedModeBanner: false,
            home: IndividualBottomTab(),
            initialRoute: "SplashScreen",
            routes: {
              "IndividualBottomTab": (context) => IndividualBottomTab(),
              "SplashScreen": (context) => SplashScreen(),
              "ReplenishmentWalletPage": (context) => ReplenishmentWalletPage(),
              "TransactionHistoryPage": (context) => TransactionHistoryPage(),
              "MyAdListPage": (context) => MyAdListPage(),
              "SectionCreateAdPage": (context) => SectionCreateAdPage(),
              "GetAccountTypePage": (context) => GetAccountTypePage(),
              "ResetIndividualPasswordPage": (context) => ResetIndividualPasswordPage(),
              "CreateApplication": (context) => CreateApplication(),
              "ApplicationListPage": (context) => ApplicationListPage(),
              "AllNewsPage": (context) => AllNewsPage(),
              "GetActivityContractorPage": (context) =>
                  GetActivityContractorPage(),
            },
          );
        }));
  }
}
