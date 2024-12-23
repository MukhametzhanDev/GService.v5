import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/darkThemeProvider.dart';
import 'package:gservice5/component/theme/styles.dart';
import 'package:gservice5/component/wallet/transaction/transactionHistoryPage.dart';
import 'package:gservice5/navigation/individual/individualBottomTab.dart';
import 'package:gservice5/pages/ad/my/myAdListPage.dart';
import 'package:gservice5/pages/application/list/applicationListPage.dart';
import 'package:gservice5/pages/application/my/myApplicationListPage.dart';
import 'package:gservice5/pages/auth/accountType/getAccountTypePage.dart';
import 'package:gservice5/pages/auth/password/individual/resetIndividualPasswordPage.dart';
import 'package:gservice5/pages/auth/registration/business/contractor/getActivityContractorPage.dart';
import 'package:gservice5/pages/create/ad/sectionCreateAdPage.dart';
import 'package:gservice5/pages/create/application/createApplication.dart';
import 'package:gservice5/pages/profile/contacts/addContactsPage.dart';
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
            home: const IndividualBottomTab(),
            initialRoute: "SplashScreen",
            routes: {
              "IndividualBottomTab": (context) => const IndividualBottomTab(),
              "SplashScreen": (context) => const SplashScreen(),
              "ReplenishmentWalletPage": (context) => const ReplenishmentWalletPage(),
              "TransactionHistoryPage": (context) => const TransactionHistoryPage(),
              "MyAdListPage": (context) => const MyAdListPage(),
              "MyApplicationListPage": (context) => const MyApplicationListPage(),
              "SectionCreateAdPage": (context) => const SectionCreateAdPage(),
              "GetAccountTypePage": (context) => const GetAccountTypePage(),
              "ResetIndividualPasswordPage": (context) =>
                  const ResetIndividualPasswordPage(),
              "CreateApplication": (context) => const CreateApplication(),
              "ApplicationListPage": (context) => const ApplicationListPage(),
              "AllNewsPage": (context) => const AllNewsPage(),
              "GetActivityContractorPage": (context) =>
                  const GetActivityContractorPage(),
              "AddContactsPage": (context) => const AddContactsPage(),
            },
          );
        }));
  }
}
