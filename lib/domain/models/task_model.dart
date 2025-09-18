class TaskModel {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String status;
  final int userId;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.userId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] ?? '',
      priority: json['priority'] ?? 'Low',
      status: json['status'] ?? 'To-Do',
      userId: json['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "dueDate": dueDate,
      "priority": priority,
      "status": status,
      "userId": userId,
    };
  }
}
