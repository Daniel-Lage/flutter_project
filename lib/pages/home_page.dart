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
  List<Contact> _contactList = <Contact>[];
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

    final newContact = args as Contact;

    setState(() {
      _contactList.add(newContact);
    });
  }

  Future<void> _goToContact(Contact contact) async {
    Object? args = await Navigator.of(
      context,
    ).pushNamed('/contact', arguments: contact);

    if (args == null) return;

    final updatedContact = args as Contact;

    final index = _contactList.indexWhere(
      (contact) => contact.name == updatedContact.name,
    );

    setState(() {
      _contactList[index] = updatedContact;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
          size: 40,
        ),
        title: Text(
          'Contatos',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushNamed("/prefs"),
          icon: Icon(Icons.settings),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ..._contactList.map(
            (contact) => Column(
              children: [
                ContactComponent(
                  contact: contact,
                  delete: () => _removeContact(contact.name),
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
