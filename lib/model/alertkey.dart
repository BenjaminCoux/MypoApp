class AlertKey {
  final String name;
  int contient;
  bool allow;

  AlertKey({required this.name, required this.contient, required this.allow});

  @override
  String toString() {
    return '{"name:"$name,"contient":$contient,"allow:"$allow}';
  }
}
