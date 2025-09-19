import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final DateTime? dueDate;
  
  @HiveField(4)
  final String priority;
  
  @HiveField(5)
  final String status;
  
  @HiveField(6)
  final int? assignedUserId;
  
  @HiveField(7)
  final DateTime createdAt;
  
  @HiveField(8)
  final DateTime updatedAt;
  
  @HiveField(9)
  final bool completed;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    required this.priority,
    required this.status,
    this.assignedUserId,
    required this.createdAt,
    required this.updatedAt,
    this.completed = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? json['title'] ?? '',
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate']) 
          : null,
      priority: json['priority'] ?? 'Medium',
      status: json['status'] ?? 'To-Do',
      assignedUserId: json['assignedUserId'] ?? json['userId'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'status': status,
      'assignedUserId': assignedUserId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completed': completed,
    };
  }

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    int? assignedUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? completed,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedUserId: assignedUserId ?? this.assignedUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completed: completed ?? this.completed,
    );
  }

  bool get isOverdue {
    if (dueDate == null || completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
           dueDate!.month == now.month &&
           dueDate!.day == now.day;
  }

  @override
  List<Object?> get props => [
    id, title, description, dueDate, priority, 
    status, assignedUserId, createdAt, updatedAt, completed
  ];
}
