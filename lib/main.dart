import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
    ),
    home: const _MyHomePage(title: 'Lista de Pessoas'),
  );
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage({required this.title});

  final String title;

  @override
  State<_MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final List<String> _personList = [];
  final TextEditingController _controller = TextEditingController();

  String text = "";

  void _addPerson() {
    setState(() {
      _personList.add(text);
    });
    _controller.clear();
  }

  void _removePerson(String person) {
    setState(() {
      _personList.remove(person);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      title: Text(
        widget.title,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: <Widget>[
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _controller,
                  onChanged: (value) => text = value,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    fillColor: Colors.red,
                    border: OutlineInputBorder(),
                    labelText: 'Pessoa',
                  ),
                ),
              ),
              IconButton(onPressed: _addPerson, icon: Icon(Icons.add)),
            ],
          ),
          ..._personList.map(
            (person) => SizedBox(
              width: 350,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('    $person'),
                  IconButton(
                    onPressed: () => _removePerson(person),
                    icon: Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
