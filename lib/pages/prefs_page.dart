import 'package:flutter/material.dart';
import 'package:flutter_project/notifiers/dark_theme_notifier.dart';
import 'package:provider/provider.dart';

class PrefsPage extends StatelessWidget {
  const PrefsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      title: Text(
        'Preferências',
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    ),
    body: ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsetsGeometry.directional(start: 65, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Provider.of<DarkThemeNotifier>(
                    context,
                    listen: false,
                  ).isDarkTheme = !Provider.of<DarkThemeNotifier>(
                    context,
                    listen: false,
                  ).isDarkTheme;
                },
                icon: Provider.of<DarkThemeNotifier>(context).isDarkTheme
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank),
              ),
              Text("Usar modo noturno"),
            ],
          ),
        ),
      ],
    ),
  );
}
