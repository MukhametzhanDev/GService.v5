import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gservice5/component/theme/darkThemeProvider.dart';
import 'package:gservice5/component/theme/styles.dart';
import 'package:gservice5/l10n/l10n.dart';
import 'package:gservice5/localization/streams/general_stream.dart';
import 'package:gservice5/navigation/routes/app_router.dart';
import 'package:gservice5/provider/adFavoriteProvider.dart';
import 'package:gservice5/provider/adFilterProvider.dart';
import 'package:gservice5/provider/applicationFavoriteProvider.dart';
import 'package:gservice5/provider/myAdFilterProvider.dart';
import 'package:gservice5/provider/nameCompanyProvider.dart';
import 'package:gservice5/provider/statusMyAdCountProvider.dart';
import 'package:gservice5/provider/walletAmountProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Index extends StatefulWidget {
  const Index({super.key, required this.appRouter});
  final AppRouter appRouter;

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  bool loader = true;
  bool appForeground = false;

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
        child: StreamBuilder<Locale>(
            stream: GeneralStreams.langaugeStream.stream,
            builder: (context, snapshot) {
              return MaterialApp.router(
                  theme:
                      Styles.themeData(themeChangeProvider.darkTheme, context),
                  debugShowCheckedModeBanner: false,
                  supportedLocales: L10n.locals,
                  locale: snapshot.data,
                  localizationsDelegates: const [
                    GlobalCupertinoLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    AppLocalizations.delegate
                  ],
                  routerConfig: widget.appRouter.config(
                    navigatorObservers: () => [AutoRouteObserver()],
                    // deepLinkBuilder: (link) async {
                    //   String path = link.uri.path;
                    //   List pathSegments = link.uri.pathSegments;
                    //   // if (!appForeground) await getData();
                    //   if (link.path.contains('product')) {
                    //     int id = int.parse(pathSegments.last);
                    //     return DeepLink([ViewAdRoute(id: id)]);
                    //   } else if (link.path.contains('application')) {
                    //     int id = int.parse(pathSegments.last);
                    //     return DeepLink([ViewApplicationRoute(id: id)]);
                    //   } else if (link.path.contains('news')) {
                    //     int id = int.parse(pathSegments.last);
                    //     return DeepLink([ViewNewsRoute(id: id)]);
                    //   } else if (link.path.contains('business')) {
                    //     int id = int.parse(pathSegments.last);
                    //     return DeepLink([ViewBusinessRoute(id: id)]);
                    //   } else if (link.path.contains('raffle')) {
                    //     return const DeepLink([ViewRaffleRoute()]);
                    //   } else {
                    //     return DeepLink.defaultPath;
                    //   }
                    // }
                  ));
            }));
  }
}
