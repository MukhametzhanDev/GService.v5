import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/component/theme/darkThemeProvider.dart';
import 'package:gservice5/component/theme/styles.dart';
import 'package:gservice5/navigation/business/businessBottomTab.dart';
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
import 'package:gservice5/provider/myAdFilterProvider.dart';
import 'package:gservice5/provider/statusMyAdCountProvider.dart';
import 'package:gservice5/provider/walletAmountProvider.dart';
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
          ChangeNotifierProvider(create: (_) => WalletAmountProvider()),
          ChangeNotifierProvider(create: (_) => StatusMyAdCountProvider()),
          ChangeNotifierProvider(create: (_) => MyAdFilterProvider()),
        ],
        child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, child) {
          // debugInvertOversizedImages = true;
          return MaterialApp(
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            debugShowCheckedModeBanner: false,
            home: const CustomerBottomTab(),
            initialRoute: "SplashScreen",
            routes: {
              "CustomerBottomTab": (context) => const CustomerBottomTab(),
              "BusinessBottomTab": (context) => const BusinessBottomTab(),
              "SplashScreen": (context) => const SplashScreen(),
              "ReplenishmentWalletPage": (context) =>
                  const ReplenishmentWalletPage(),
              "TransactionHistoryPage": (context) =>
                  const TransactionHistoryPage(),
              "MyAdListPage": (context) => const MyAdListPage(),
              "MyApplicationListPage": (context) =>
                  const MyApplicationListPage(),
              "SectionCreateAdPage": (context) => const SectionCreateAdPage(),
              "GetAccountTypePage": (context) => const GetAccountTypePage(),
              "ResetCustomerPasswordPage": (context) =>
                  const ResetCustomerPasswordPage(),
              "CreateApplication": (context) => const CreateApplication(),
              "ApplicationListPage": (context) => const ApplicationListPage(),
              "AllNewsPage": (context) => const AllNewsPage(),
              "AddContactsPage": (context) => const AddContactsPage(),
              "CompaniesMainPage": (context) => const CompaniesMainPage(),
              "RegistrationBusinessPage": (context) =>
                  const RegistrationBusinessPage(),
              "CustomerProfilePage": (context) => const CustomerProfilePage(),
            },
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: GetIt.I<FirebaseAnalytics>())
            ],
          );
        }));
  }
}
