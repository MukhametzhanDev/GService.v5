// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:gservice5/navigation/business/businessBottomTab.dart' as _i1;
import 'package:gservice5/navigation/customer/customerBottomTab.dart' as _i2;
import 'package:gservice5/pages/ad/viewAdPage.dart' as _i4;
import 'package:gservice5/pages/application/viewApplicationPage.dart' as _i5;
import 'package:gservice5/pages/author/business/viewBusinessPage.dart' as _i6;
import 'package:gservice5/pages/profile/news/viewNewsPage.dart' as _i7;
import 'package:gservice5/pages/raffle/viewRafflePage.dart' as _i8;
import 'package:gservice5/pages/splash/splashScreen.dart' as _i3;

/// generated route for
/// [_i1.BusinessBottomTab]
class BusinessBottomRoute extends _i9.PageRouteInfo<void> {
  const BusinessBottomRoute({List<_i9.PageRouteInfo>? children})
      : super(
          BusinessBottomRoute.name,
          initialChildren: children,
        );

  static const String name = 'BusinessBottomRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.BusinessBottomTab();
    },
  );
}

/// generated route for
/// [_i2.CustomerBottomTab]
class CustomerBottomRoute extends _i9.PageRouteInfo<void> {
  const CustomerBottomRoute({List<_i9.PageRouteInfo>? children})
      : super(
          CustomerBottomRoute.name,
          initialChildren: children,
        );

  static const String name = 'CustomerBottomRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.CustomerBottomTab();
    },
  );
}

/// generated route for
/// [_i3.SplashScreen]
class SplashRoute extends _i9.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    _i10.Key? key,
    String? path,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(
            key: key,
            path: path,
          ),
          rawPathParams: {'path': path},
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SplashRouteArgs>(
          orElse: () => SplashRouteArgs(path: pathParams.optString('path')));
      return _i3.SplashScreen(
        key: args.key,
        path: args.path,
      );
    },
  );
}

class SplashRouteArgs {
  const SplashRouteArgs({
    this.key,
    this.path,
  });

  final _i10.Key? key;

  final String? path;

  @override
  String toString() {
    return 'SplashRouteArgs{key: $key, path: $path}';
  }
}

/// generated route for
/// [_i4.ViewAdPage]
class ViewAdRoute extends _i9.PageRouteInfo<ViewAdRouteArgs> {
  ViewAdRoute({
    _i10.Key? key,
    required int id,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ViewAdRoute.name,
          args: ViewAdRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ViewAdRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ViewAdRouteArgs>(
          orElse: () => ViewAdRouteArgs(id: pathParams.getInt('id')));
      return _i4.ViewAdPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class ViewAdRouteArgs {
  const ViewAdRouteArgs({
    this.key,
    required this.id,
  });

  final _i10.Key? key;

  final int id;

  @override
  String toString() {
    return 'ViewAdRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i5.ViewApplicationPage]
class ViewApplicationRoute extends _i9.PageRouteInfo<ViewApplicationRouteArgs> {
  ViewApplicationRoute({
    _i10.Key? key,
    required int id,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ViewApplicationRoute.name,
          args: ViewApplicationRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ViewApplicationRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ViewApplicationRouteArgs>(
          orElse: () => ViewApplicationRouteArgs(id: pathParams.getInt('id')));
      return _i5.ViewApplicationPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class ViewApplicationRouteArgs {
  const ViewApplicationRouteArgs({
    this.key,
    required this.id,
  });

  final _i10.Key? key;

  final int id;

  @override
  String toString() {
    return 'ViewApplicationRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i6.ViewBusinessPage]
class ViewBusinessRoute extends _i9.PageRouteInfo<ViewBusinessRouteArgs> {
  ViewBusinessRoute({
    _i10.Key? key,
    required int id,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ViewBusinessRoute.name,
          args: ViewBusinessRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ViewBusinessRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ViewBusinessRouteArgs>(
          orElse: () => ViewBusinessRouteArgs(id: pathParams.getInt('id')));
      return _i6.ViewBusinessPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class ViewBusinessRouteArgs {
  const ViewBusinessRouteArgs({
    this.key,
    required this.id,
  });

  final _i10.Key? key;

  final int id;

  @override
  String toString() {
    return 'ViewBusinessRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i7.ViewNewsPage]
class ViewNewsRoute extends _i9.PageRouteInfo<ViewNewsRouteArgs> {
  ViewNewsRoute({
    _i10.Key? key,
    required int id,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ViewNewsRoute.name,
          args: ViewNewsRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ViewNewsRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ViewNewsRouteArgs>(
          orElse: () => ViewNewsRouteArgs(id: pathParams.getInt('id')));
      return _i7.ViewNewsPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class ViewNewsRouteArgs {
  const ViewNewsRouteArgs({
    this.key,
    required this.id,
  });

  final _i10.Key? key;

  final int id;

  @override
  String toString() {
    return 'ViewNewsRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i8.ViewRafflePage]
class ViewRaffleRoute extends _i9.PageRouteInfo<void> {
  const ViewRaffleRoute({List<_i9.PageRouteInfo>? children})
      : super(
          ViewRaffleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ViewRaffleRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.ViewRafflePage();
    },
  );
}
