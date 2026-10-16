class Todo {
  String id;
  String title;
  bool isComplete;

  Todo({
    this.id = '',
    required this.title,
    this.isComplete = false,
  });

  bool get isDone => isComplete;
  set isDone(bool value) => isComplete = value;
}

