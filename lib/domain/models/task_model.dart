class Task {
  final int id;
  final String title;
  String descriptions;
  int status;
  double hours;
  String temporaryUUID;
  List<String> comments;
  Task(
      {required this.descriptions,
      required this.status,
      required this.hours,
      required this.temporaryUUID,
      required this.comments,
      required this.id,
      required this.title});

  factory Task.fromJson(Map<String, dynamic> json) {
    // Необходимы првоерки, сильная точка отказа если в Json одно нужное поле - null. (Никогда не доверяй Backend'ерам, всегда проверяй )
    return Task(
      id: json['id'],
      title: json['title'],
      descriptions: json['descriptions'],
      status: json['status'],
      hours: json['hours'].toDouble(),
      temporaryUUID: json['temporaryUUID'],
      comments: List<String>.from(json['comments'] ?? []),
    );
  }
}
