class Task {
  int id;
  String title;
  String desc;
  DateTime date;
  int status; // 0 - incomplete, 1- complete

  Task({this.title, this.date, this.desc, this.status});
  Task.withId({this.id, this.title, this.desc, this.date, this.status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['desc'] = desc;
    map['date'] = date.toIso8601String();
    map['status'] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
        id: map['id'],
        title: map['title'],
        desc: map['desc'],
        date: DateTime.parse(map['date']),
        status: map['status']);
  }
}
