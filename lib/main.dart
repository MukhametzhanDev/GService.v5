import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/analytics/event_name.constan.dart';
import 'package:gservice5/firebase_options.dart';
import 'package:gservice5/navigation/index.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('ru_RU', null);

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  //Аналитика Google Analytics
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  GetIt.I.registerSingleton(analytics);

  await GetIt.I<FirebaseAnalytics>().setDefaultEventParameters({
    GAKey.platform: Platform.operatingSystem,
    GAKey.version: packageInfo.version,
    GAKey.build: packageInfo.buildNumber,
    GAKey.installerStore: packageInfo.installerStore
  });

  runApp(const Index());
} 