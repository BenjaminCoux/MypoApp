class Alert {
  String title;
  String content;
  final days;
  final cibles;
  bool active = false;

  Alert(
      {required this.title,
      required this.content,
      required this.days,
      required this.cibles});
}
