class TransactionObject {
  final String contactName;
  final int id;
  final int value;
  final TransactionType type;

  TransactionObject({
    required this.contactName,
    required this.id,
    required this.value,
    required this.type,
  });
}

enum TransactionType { plus, minus }
