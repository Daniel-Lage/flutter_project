class Transaction {
  final String personName;
  final int id;
  final int value;
  final TransactionType type;

  Transaction({
    required this.personName,
    required this.id,
    required this.value,
    required this.type,
  });
}

enum TransactionType { plus, minus }
