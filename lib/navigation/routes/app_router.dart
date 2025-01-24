import 'package:auto_route/auto_route.dart';
import 'package:gservice5/navigation/routes/app_router.gr.dart';


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
        AutoRoute(page: ViewAdRoute.page, path: '/product/:id'),
        AutoRoute(page: ViewApplicationRoute.page, path: '/application/:id'),
        AutoRoute(page: ViewNewsRoute.page, path: '/news/:url'),
        AutoRoute(page: ViewRaffleRoute.page, path: '/raffle'),
        AutoRoute(page: ViewBusinessRoute.page, path: '/companies/:id'),
        RedirectRoute(path: '*', redirectTo: '/'),
      ];
}

// command
//  flutter pub run build_runner build --delete-conflicting-outputs      