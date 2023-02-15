class Exercise {
  String name;
  String description;
  DateTime startedAt;
  DateTime finishedAt;

  Exercise({
    this.name = '',
    this.description = '',
    required this.startedAt,
    required this.finishedAt,
  });
}
