import 'package:flutter/material.dart';
import 'package:flutter_project/components/person_component.dart';
import 'package:flutter_project/models/person_model.dart';
import 'package:flutter_project/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Person> _personList = <Person>[];
  final TextEditingController _controller = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;

  String text = "";

  void _addPerson() {
    if (_personList.any((person) => person.name == text)) return;
    final person = Person(name: text);
    _databaseService.addPerson(person);
    setState(() {
      _personList.add(person);
      text = "";
    });
    _controller.clear();
  }

  void _removePerson(String name) {
    _databaseService.removePerson(name);
    setState(() {
      _personList.removeWhere((person) => person.name == name);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Object? args = ModalRoute.of(context)?.settings.arguments;

      if (args == null) {
        loadState();
        return;
      }

      final updatedPerson = args as Person;

      final index = _personList.indexWhere(
        (person) => person.name == updatedPerson.name,
      );

      setState(() {
        _personList[index] = updatedPerson;
      });
    });
  }

  Future<void> loadState() async {
    final personTable = await _databaseService.getPeopleTable();

    setState(() {
      _personList = personTable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          'Lista de Pessoas',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushNamed("/prefs"),
          icon: Icon(Icons.settings),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: <Widget>[
              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => text.isEmpty ? null : _addPerson(),
                    onChanged: (value) {
                      setState(() {
                        (text = value);
                      });
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: text.isEmpty ? null : _addPerson,
                icon: Icon(Icons.add),
              ),
            ],
          ),
          ..._personList.map(
            (person) => PersonComponent(
              person: person,
              delete: () => _removePerson(person.name),
            ),
          ),
        ],
      ),
    );
  }
}
