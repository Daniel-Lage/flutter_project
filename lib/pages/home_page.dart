import 'package:flutter/material.dart';
import 'package:flutter_project/components/contact_component.dart';
import 'package:flutter_project/models/contact_model.dart';
import 'package:flutter_project/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ContactObject> _contactList = <ContactObject>[];
  ContactCompareKey? _compareKey;
  bool _listIsReversed = false;

  final DatabaseService _databaseService = DatabaseService.instance;

  void _removeContact(String name) {
    _databaseService.removeContact(name);
    setState(() {
      _contactList.removeWhere((contact) => contact.name == name);
    });
  }

  _HomePageState() {
    loadState();
  }

  Future<void> loadState() async {
    final contactTable = await _databaseService.getContactsTable();

    setState(() {
      _contactList = contactTable;
    });
  }

  Future<void> _goToNewContact() async {
    Object? args = await Navigator.of(context).pushNamed("/new");

    if (args == null) return;

    final newContact = args as ContactObject;

    setState(() {
      _contactList.add(newContact);
    });
  }

  Future<void> _goToContact(ContactObject contact) async {
    Object? args = await Navigator.of(
      context,
    ).pushNamed('/contact', arguments: contact);

    if (args == null) return;

    final updatedContact = args as ContactObject;

    final index = _contactList.indexWhere(
      (contact) => contact.name == updatedContact.name,
    );

    setState(() {
      _contactList[index] = updatedContact;
    });
  }

  Future<void> _goToPrefs() async {
    Object? args = await Navigator.of(context).pushNamed("/settings");

    if (args == null) return;

    final updatedSettings = args as Map<String, bool>;

    if (updatedSettings["isUsingLocalContacts"] == true) {
      loadState();
    }
  }

  Future<void> _removeContactDialogBuilder(BuildContext context, String name) =>
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Excluir contato?"),
          content: Text("As transações armazenadas também serão perdidas."),
          actions: [
            IconButton(
              onPressed: () {
                _removeContact(name);
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.remove),
              style: IconButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      );

  List<ContactObject> _getSortedContacts() {
    if (_compareKey != null) {
      switch (_compareKey) {
        case ContactCompareKey.debt:
          _contactList.sort((a, b) => a.debt.compareTo(b.debt));
          break;
        case ContactCompareKey.name:
          _contactList.sort((a, b) => a.name.compareTo(b.name));
          break;
        default:
          break;
      }
    }
    return _listIsReversed ? _contactList.reversed.toList() : _contactList;
  }

  void _reverseList() {
    setState(() {
      _listIsReversed = !_listIsReversed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
          size: 35,
        ),
        title: Text(
          'Contatos',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        leading: IconButton(
          onPressed: _goToPrefs,
          icon: Icon(Icons.settings),
          padding: EdgeInsetsGeometry.all(5),
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondary,
            padding: EdgeInsetsGeometry.directional(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => setState(() {
                          _compareKey = ContactCompareKey.name;
                        }),
                        child: Text(
                          "Nome",
                          style: _compareKey == ContactCompareKey.name
                              ? TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                )
                              : TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() {
                          _compareKey = ContactCompareKey.debt;
                        }),
                        child: Text(
                          "Dívida",
                          style: _compareKey == ContactCompareKey.debt
                              ? TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                )
                              : TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  color: Theme.of(context).colorScheme.onSecondary,
                  onPressed: _reverseList,
                  icon: Icon(
                    _listIsReversed
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                  ),
                  padding: EdgeInsetsGeometry.all(5),
                ),
              ],
            ),
          ),
          ..._getSortedContacts().map(
            (contact) => Column(
              children: [
                ContactComponent(
                  contact: contact,
                  delete: () =>
                      _removeContactDialogBuilder(context, contact.name),
                  goTo: () => _goToContact(contact),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  height: 2,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        onPressed: _goToNewContact,
        icon: Icon(Icons.add),
        iconSize: 40,
        color: Theme.of(context).colorScheme.onPrimary,
        padding: EdgeInsetsGeometry.all(10),
      ),
    );
  }
}
