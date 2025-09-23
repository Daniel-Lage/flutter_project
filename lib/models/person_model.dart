class Person {
  final String name;
  int debt;
  Person({required this.name, this.debt = 0});

  Map<String, Object> toMap() => {'name': name, "debt": debt};
}
