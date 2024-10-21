import 'package:flutter/material.dart';
import 'package:gservice5/component/theme/darkThemeProvider.dart';
import 'package:gservice5/component/theme/styles.dart';
import 'package:gservice5/navigation/bottomTab.dart';
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
        ],
        child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, child) {
          return MaterialApp(
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            debugShowCheckedModeBanner: false,
            home: BottomTab(),
          );
        }));
  }
}
