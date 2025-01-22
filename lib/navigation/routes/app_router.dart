import 'package:auto_route/auto_route.dart'; // аннотации и классы auto_route
import 'package:gservice5/navigation/customer/customerBottomTab.dart';
import 'package:gservice5/navigation/routes/app_router.gr.dart';
import 'package:gservice5/pages/author/business/viewBusinessPage.dart';
import 'package:gservice5/pages/raffle/viewRafflePage.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Tab|Page|Screen,Route',
)
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/', initial: true),
        AutoRoute(page: CustomerBottomRoute.page),
        AutoRoute(page: BusinessBottomRoute.page),
        AutoRoute(page: ViewAdRoute.page, path: '/ad/:id'),
        AutoRoute(page: ViewApplicationRoute.page, path: '/application/:id'),
        AutoRoute(page: ViewNewsRoute.page, path: '/news/:id'),
        AutoRoute(page: ViewRaffleRoute.page, path: '/raffle'),
        AutoRoute(page: ViewBusinessRoute.page, path: '/business'),
      ];

  
}
