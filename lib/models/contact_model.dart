class Contact {
  final String name;
  int debt;
  Contact({required this.name, this.debt = 0});

  Map<String, Object> toMap() => {'name': name, "debt": debt};
}
