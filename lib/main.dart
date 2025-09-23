import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project/dark_theme_notifier.dart';
import 'package:flutter_project/pages/home_page.dart';
import 'package:flutter_project/pages/person_page.dart';
import 'package:flutter_project/pages/prefs_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  databaseFactory = databaseFactoryFfi;

  runApp(
    ChangeNotifierProvider(
      create: (_) => DarkThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter Project',

    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromARGB(255, 100, 20, 40),
        brightness: Provider.of<DarkThemeNotifier>(context).isDarkTheme
            ? Brightness.dark
            : Brightness.light,
      ),
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/person': (context) => PersonPage(),
      '/prefs': (context) => PrefsPage(),
    },
  );
}
