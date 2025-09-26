import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/components/transaction_component.dart';
import 'package:flutter_project/currency_input_formatter.dart';
import 'package:flutter_project/models/contact_model.dart';
import 'package:flutter_project/models/transaction_model.dart';
import 'package:flutter_project/services/database_service.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final String initialText = CurrencyInputFormatter.formatter.format(0);
  Contact? _contact;
  List<Transaction> _transactionsList = <Transaction>[];
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;

  int toValue = 0;
  int fromValue = 0;

  void _doTransaction() {
    if (_contact == null) return;

    final value = toValue == 0 ? fromValue : -toValue;

    final newTransaction = Transaction(
      contactName: _contact!.name,
      id: _transactionsList.length,
      value: value.abs(),
      type: toValue == 0 ? TransactionType.plus : TransactionType.minus,
    );

    setState(() {
      _transactionsList.add(newTransaction);
      _contact?.debt -= value;
      toValue = 0;
      fromValue = 0;
    });

    _databaseService.updateContact(_contact!);
    _databaseService.addTransaction(newTransaction);
    _toController.text = initialText;
    _fromController.text = initialText;
  }

  @override
  void initState() {
    super.initState();
    _toController.text = initialText;
    _fromController.text = initialText;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Object? args = ModalRoute.of(context)?.settings.arguments;

      if (args == null) return;

      Contact selectedContact = args as Contact;
      setState(() {
        _contact = selectedContact;
      });
      loadState();
    });
  }

  Future<void> loadState() async {
    final transactionsTable = await _databaseService.getContactsTransactions(
      _contact!.name,
    );

    setState(() {
      _transactionsList = transactionsTable;
    });
  }

  Widget loading() => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
    ),
    body: Center(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Valor',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => _contact == null
      ? loading()
      : Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              _contact!.name,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onPrimary,
            ),

            leading: BackButton(
              onPressed: () {
                Navigator.pop(context, _contact);
              },
            ),
          ),
          body: Center(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  resolveDebt(_contact!.debt, _contact!.name),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 75,
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter(),
                          ],
                          controller: _toController,
                          onChanged: (text) {
                            setState(() {
                              toValue =
                                  (CurrencyInputFormatter.formatter.parse(
                                            text,
                                          ) *
                                          100)
                                      .floor();
                            });
                          },
                          onSubmitted: (_) => toValue == 0 && fromValue == 0
                              ? null
                              : _doTransaction(),
                          readOnly: fromValue != 0,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Você',
                          ),
                        ),
                      ),
                      IconButton(
                        color: toValue == 0 && fromValue == 0
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                        constraints: BoxConstraints(),
                        onPressed: toValue == 0 && fromValue == 0
                            ? null
                            : () => _doTransaction(),
                        icon: Icon(
                          toValue == 0 && fromValue == 0
                              ? Icons.remove
                              : toValue == 0
                              ? Icons.arrow_back
                              : Icons.arrow_forward,
                        ),
                        iconSize: 25,
                        padding: EdgeInsets.zero,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 75,
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter(),
                          ],
                          controller: _fromController,
                          onChanged: (text) {
                            setState(() {
                              fromValue =
                                  (CurrencyInputFormatter.formatter.parse(
                                            text,
                                          ) *
                                          100)
                                      .floor();
                            });
                          },
                          onSubmitted: (_) => toValue == 0 && fromValue == 0
                              ? null
                              : _doTransaction(),
                          readOnly: toValue != 0,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: _contact!.name,
                          ),
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
                  (transaction) =>
                      TransactionComponent(transaction: transaction),
                ),
              ],
            ),
          ),
        );
}

String resolveDebt(int debt, String name) {
  String debtString = CurrencyInputFormatter.formatter.format(debt.abs() / 100);
  if (debt > 0) return "$name te deve $debtString";
  if (debt < 0) return "Você deve $debtString a $name";
  return "Você não tem divida com $name";
}
