import 'package:flutter_project/models/person_model.dart';
import 'package:flutter_project/models/transaction_model.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  final String _peopleTableName = "people";
  final String _peopleNameColumnName = "name";
  final String _peopleDebtColumnName = "debt";

  final String _transactionsTableName = "transactions";
  final String _transactionsPersonNameColumnName = "personName";
  final String _transactionsIdColumnName = "id";
  final String _transactionsValueColumnName = "value";
  final String _transactionsTypeColumnName = "type";

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async => await openDatabase(
    join(await getDatabasesPath(), 'main.db'),
    version: 1,
    onCreate: (db, version) {
      db.execute('''CREATE TABLE $_peopleTableName (
        $_peopleNameColumnName TEXT PRIMARY KEY,
        $_peopleDebtColumnName INTEGER NOT NULL
      )''');
      db.execute('''CREATE TABLE $_transactionsTableName (
        $_transactionsIdColumnName INTEGER PRIMARY KEY,
        $_transactionsPersonNameColumnName TEXT,
        $_transactionsValueColumnName INTEGER,
        $_transactionsTypeColumnName INTEGER
      )''');
    },
  );

  Future<void> addPerson(Person person) async {
    final db = await database;
    await db.insert(_peopleTableName, {
      _peopleNameColumnName: person.name,
      _peopleDebtColumnName: person.debt,
    });
  }

  Future<void> removePerson(String name) async {
    final db = await database;
    await db.delete(
      _peopleTableName,
      where: '$_peopleNameColumnName = ?',
      whereArgs: [name],
    );
    await db.delete(
      _transactionsTableName,
      where: '$_transactionsPersonNameColumnName = ?',
      whereArgs: [name],
    );
  }

  Future<List<Person>> getPeopleTable() async {
    final db = await database;
    final peopleTable = await db.query(_peopleTableName);
    return peopleTable
        .map(
          (personMap) => Person(
            name: personMap[_peopleNameColumnName] as String,
            debt: personMap[_peopleDebtColumnName] as int,
          ),
        )
        .toList();
  }

  Future<void> updatePerson(Person person) async {
    final db = await database;
    await db.update(
      _peopleTableName,
      person.toMap(),
      where: '$_peopleNameColumnName = ?',
      whereArgs: [person.name],
    );
  }

  Future<List<Transaction>> getTransactionsTable() async {
    final db = await database;
    final transactionsTable = await db.query(_transactionsTableName);
    return transactionsTable
        .map(
          (transactionMap) => Transaction(
            id: transactionMap[_transactionsIdColumnName] as int,
            personName:
                transactionMap[_transactionsPersonNameColumnName] as String,
            value: transactionMap[_transactionsValueColumnName] as int,
            type: transactionMap[_transactionsTypeColumnName] == 1
                ? TransactionType.minus
                : TransactionType.plus,
          ),
        )
        .toList();
  }

  Future<List<Transaction>> getPersonsTransactions(String personName) async {
    final db = await database;
    final transactionsTable = await db.query(
      _transactionsTableName,
      where: '$_transactionsPersonNameColumnName = ?',
      whereArgs: [personName],
    );
    return transactionsTable
        .map(
          (transactionMap) => Transaction(
            id: transactionMap[_transactionsIdColumnName] as int,
            personName:
                transactionMap[_transactionsPersonNameColumnName] as String,
            value: transactionMap[_transactionsValueColumnName] as int,
            type: transactionMap[_transactionsTypeColumnName] == 1
                ? TransactionType.minus
                : TransactionType.plus,
          ),
        )
        .toList();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final db = await database;
    await db.insert(_transactionsTableName, {
      _transactionsPersonNameColumnName: transaction.personName,
      _transactionsIdColumnName: transaction.id,
      _transactionsValueColumnName: transaction.value,
      _transactionsTypeColumnName: transaction.type == TransactionType.minus
          ? 1
          : 0,
    });
  }
}
