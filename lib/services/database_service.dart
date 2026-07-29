import 'package:myledger/models/contact_model.dart';
import 'package:myledger/models/payment_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'main.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        db.execute('''CREATE TABLE ${ContactObject.tableName} (
        ${ContactObject.nameColumnName} TEXT PRIMARY KEY,
        ${ContactObject.balanceColumnName} INTEGER NOT NULL
      )''');
        db.execute('''CREATE TABLE ${PaymentObject.tableName} (
        ${PaymentObject.idColumnName} INTEGER PRIMARY KEY,
        ${PaymentObject.contactNameColumnName} TEXT,
        ${PaymentObject.valueColumnName} INTEGER,
        ${PaymentObject.typeColumnName} INTEGER,
        ${PaymentObject.createdAtColumnName} INTEGER NOT NULL,
        ${PaymentObject.descriptionColumnName} TEXT
      )''');
      },
    );
  }

  Future<void> resetDatabase() async {
    String databasesPath = await getDatabasesPath();

    final path = join(databasesPath, 'main.db');

    final db = await database;

    await db.close();

    await deleteDatabase(path);

    _database = await _initDatabase();
  }

  Future<void> addContact(ContactObject contact) async {
    final db = await database;

    final hasContact = (await db.query(
      ContactObject.tableName,
      where: '${ContactObject.nameColumnName} = ?',
      whereArgs: [contact.name],
    )).isNotEmpty;

    if (!hasContact) {
      await db.insert(ContactObject.tableName, contact.toMap());
    }
  }

  Future<List<ContactObject>> getContactsTable() async {
    final db = await database;

    final contactsTable = await db.query(ContactObject.tableName);

    return contactsTable
        .map((contactMap) => ContactObject.fromMap(contactMap))
        .toList();
  }

  Future<ContactObject?> getContactByName(String name) async {
    final db = await database;

    final contactsTable = await db.query(
      ContactObject.tableName,
      where: '${ContactObject.nameColumnName} = ?',
      whereArgs: [name],
    );

    if (contactsTable.isEmpty) return null;

    final contactMap = contactsTable.first;

    return ContactObject.fromMap(contactMap);
  }

  Future<void> updateContact(ContactObject contact) async {
    final db = await database;

    await db.update(
      ContactObject.tableName,
      contact.toMap(),
      where: '${ContactObject.nameColumnName} = ?',
      whereArgs: [contact.name],
    );
  }

  Future<void> deleteContact(String name) async {
    final db = await database;

    await db.delete(
      ContactObject.tableName,
      where: '${ContactObject.nameColumnName} = ?',
      whereArgs: [name],
    );

    await db.delete(
      PaymentObject.tableName,
      where: '${PaymentObject.contactNameColumnName} = ?',
      whereArgs: [name],
    );
  }

  Future<int> addPayment(PaymentObject payment) async {
    // Returns payment id
    final db = await database;

    final id = await db.insert(PaymentObject.tableName, payment.toMap());

    return id;
  }

  Future<List<PaymentObject>> getContactsPayments(String contactName) async {
    final db = await database;

    final paymentsTable = await db.query(
      PaymentObject.tableName,
      where: '${PaymentObject.contactNameColumnName} = ?',
      whereArgs: [contactName],
    );

    return paymentsTable
        .map((paymentMap) => PaymentObject.fromMap(paymentMap))
        .toList();
  }

  Future<PaymentObject?> getPaymentById(int id) async {
    final db = await database;

    final paymentsTable = await db.query(
      PaymentObject.tableName,
      where: '${PaymentObject.idColumnName} = ?',
      whereArgs: [id],
    );

    if (paymentsTable.isEmpty) return null;

    final paymentMap = paymentsTable.first;

    return PaymentObject.fromMap(paymentMap);
  }

  Future<int> updatePayment(PaymentObject payment) async {
    final db = await database;

    final result = await db.update(
      PaymentObject.tableName,
      payment.toMap(),
      where: '${PaymentObject.idColumnName} = ?',
      whereArgs: [payment.id],
    );

    return result;
  }

  Future<int> deletePayment(PaymentObject payment) async {
    final db = await database;

    final result = await db.delete(
      PaymentObject.tableName,
      where: '${PaymentObject.idColumnName} = ?',
      whereArgs: [payment.id],
    );

    return result;
  }
}
