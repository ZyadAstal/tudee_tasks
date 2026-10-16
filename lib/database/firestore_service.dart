import 'package:cloud_firestore/cloud_firestore.dart';
import 'todo.dart';

class FirestoreService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Todo todo) async {
    await tasks.add({
      'title': todo.title,
      'isComplete': todo.isComplete,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<List<Todo>> getTasks() {
    return tasks.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Todo(
          id: doc.id,
          title: data['title'] ?? '',
          isComplete: data['isComplete'] ?? false,
        );
      }).toList();
    });
  }

  Future<void> updateTask(Todo todo) async {
    await tasks.doc(todo.id).update({
      'title': todo.title,
      'isComplete': todo.isComplete,
    });
  }

  Future<void> deleteTask(String id) async {
    await tasks.doc(id).delete();
  }
}
