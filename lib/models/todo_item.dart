// lib/models/todo_item.dart

class TodoItem {
  String title;
  bool isCompleted;

  TodoItem({
    required this.title,
    this.isCompleted = false,
  });
}
