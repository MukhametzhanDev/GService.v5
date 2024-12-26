import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gservice5/firebase_options.dart';
import 'package:gservice5/navigation/index.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('ru_RU', null);

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  GetIt.I.registerSingleton(analytics);
  
  runApp(const Index());
}
