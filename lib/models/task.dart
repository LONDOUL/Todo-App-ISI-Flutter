import 'categories.dart';

class Task {
  int? id;
  final String title;
  final bool isDone;
  final Categories category;

  Task(
      {this.id,
      required this.title,
      required this.isDone,
      required this.category});

  factory Task.fromJson(Map<String, dynamic> jsonString) {
    return Task(
      id: jsonString["id"],
      isDone: jsonString['done'],
      title: jsonString['title'],
      category: jsonString['category'] == 'Business'
          ? Categories.Business
          : Categories.Personal,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'done': isDone,
        'category': category == Categories.Business ? 'Business' : 'Personal'
      };
}
