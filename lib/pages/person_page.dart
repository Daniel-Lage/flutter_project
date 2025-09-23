import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/components/main_person_component.dart';
import 'package:flutter_project/components/transaction_component.dart';
import 'package:flutter_project/models/person_model.dart';
import 'package:flutter_project/models/transaction_model.dart';
import 'package:flutter_project/services/database_service.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  Person? _person;
  List<Transaction> _transactionsList = <Transaction>[];
  final TextEditingController _controller = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;

  int value = 0;

  void _doMinus() {
    if (_person == null) return;
    final newTransaction = Transaction(
      personName: _person!.name,
      id: _transactionsList.length,
      value: value,
      type: TransactionType.minus,
    );
    setState(() {
      _transactionsList.add(newTransaction);
      _person?.debt -= value;
      value = 0;
    });
    _databaseService.updatePerson(_person!);
    _databaseService.addTransaction(newTransaction);
    _controller.clear();
  }

  void _doPlus() {
    if (_person == null) return;
    final newTransaction = Transaction(
      personName: _person!.name,
      id: _transactionsList.length,
      value: value,
      type: TransactionType.plus,
    );
    setState(() {
      _transactionsList.add(newTransaction);
      _person?.debt += value;
      value = 0;
    });
    _databaseService.updatePerson(_person!);
    _databaseService.addTransaction(newTransaction);
    _controller.clear();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Object? args = ModalRoute.of(context)?.settings.arguments;

      if (args == null) return;

      Person selectedPerson = args as Person;
      setState(() {
        _person = selectedPerson;
      });
      loadState();
    });
  }

  Future<void> loadState() async {
    final transactionsTable = await _databaseService.getPersonsTransactions(
      _person!.name,
    );

    setState(() {
      _transactionsList = transactionsTable;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        'Pessoa',
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),

      leading: BackButton(
        onPressed: () {
          Navigator.pop(context, _person);
        },
      ),
    ),
    body: Center(
      child: ListView(
        children: <Widget>[
          MainPersonComponent(person: _person),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: _controller,
                    onChanged: (text) {
                      setState(() {
                        if (text.isEmpty) {
                          value = 0;
                        } else {
                          value = int.parse(text);
                        }
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Valor',
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  width: 40,
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      width: value == 0 ? 1 : 2,
                      color: value == 0
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        color: value == 0
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                        constraints: BoxConstraints(),
                        onPressed: value == 0 ? null : () => _doPlus(),
                        icon: Icon(Icons.add),
                        iconSize: 25,
                        padding: EdgeInsets.zero,
                      ),
                      IconButton(
                        color: value == 0
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                        onPressed: value == 0 ? null : () => _doMinus(),
                        icon: Icon(Icons.remove),
                        iconSize: 25,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Transações',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          ..._transactionsList.map(
            (transaction) => TransactionComponent(transaction: transaction),
          ),
        ],
      ),
    ),
  );
}
