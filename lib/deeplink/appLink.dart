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

  void _onReceivedDeepLink(Uri uri, BuildContext context) {
    debugPrint('deep link: $uri');
    final path = uri.path; // "/invite/123"
    print(path);
    context.router.pushNamed(path);
  }
}
