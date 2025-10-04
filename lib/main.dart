import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project/notifiers/preferences_notifier.dart';
import 'package:flutter_project/pages/home_page.dart';
import 'package:flutter_project/pages/contact_page.dart';
import 'package:flutter_project/pages/new_contact_page.dart';
import 'package:flutter_project/pages/settings_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => PreferenceNotifier(),
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
        brightness: Provider.of<PreferenceNotifier>(context).isDarkTheme
            ? Brightness.dark
            : Brightness.light,
      ),
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/contact': (context) => ContactPage(),
      '/settings': (context) => SettingsPage(),
      '/new': (context) => NewContactPage(),
    },
  );
}
