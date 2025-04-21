class TimeEntry {
  String id;
  String projectId;
  String taskId;
  DateTime date;
  double hours;
  String note;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.date,
    required this.hours,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'taskId': taskId,
        'date': date.toIso8601String(),
        'hours': hours,
        'note': note,
      };

  factory TimeEntry.fromJson(Map<String, dynamic> json) => TimeEntry(
        id: json['id'],
        projectId: json['projectId'],
        taskId: json['taskId'],
        date: DateTime.parse(json['date']),
        hours: json['hours'],
        note: json['note'],
      );
}
