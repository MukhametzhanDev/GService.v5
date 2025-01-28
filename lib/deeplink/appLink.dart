import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class AppLink {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _uriSubscription;

  Future<void> initDeepLinks(context) async {
    _appLinks = AppLinks();
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _onReceivedDeepLink(initialUri, context);
    }

    _uriSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      _onReceivedDeepLink(uri, context);
    }, onError: (err) {
      debugPrint('error deeplink: $err');
    });
  }

  final validPaths = [
    '/product',
    '/application',
    '/news',
    '/companies',
    '/raffle'
  ];

  void _onReceivedDeepLink(Uri uri, BuildContext context) {
    final path = uri.path;
    if (validPaths.any((validPath) => path.startsWith(validPath))) {
      context.router.pushNamed(path);
    } else {
      // Обработка неверного пути
      debugPrint('Invalid path: $path');
      // Например, перенаправить на страницу ошибки
      // context.router.pushNamed('/not-found');
    }

    // debugPrint('deep link: $uri');
    // final path = uri.path; // "/invite/123"
    // print(path);
    // context.router.pushNamed(path);
  }

  void dispose() {
    _uriSubscription?.cancel();
  }
}
