class Todo {
  String id;
  String title;
  int dueDate;
  bool isCompleted;
  int createdAt;
  int? completedAt;

  Todo({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  // Convert from Firebase snapshot
  factory Todo.fromJson(String id, Map<dynamic, dynamic> json) {
    return Todo(
      id: id,
      title: json['title'] as String,
      dueDate: json['dueDate'] as int,
      isCompleted: json['isCompleted'] as bool,
      createdAt: json['createdAt'] as int,
      completedAt: json['completedAt'] as int?,
    );
  }

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'completedAt': completedAt,
    };
  }
}