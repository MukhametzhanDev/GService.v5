import 'package:flutter/material.dart';
import 'package:gservice5/navigation/index.dart';
import 'package:gservice5/navigation/routes/app_router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);
  final initialUri = Uri.base;
  print('Initial URI: $initialUri');
  final AppRouter appRouter = AppRouter();
  runApp(Index(appRouter: appRouter));
}
