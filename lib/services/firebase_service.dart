import 'package:firebase_database/firebase_database.dart';
import '../models/todo.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('todos');

  Stream<List<Todo>> getTodos() {
    return _database.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      return data.entries.map((entry) {
        return Todo.fromJson(entry.key, entry.value as Map<dynamic, dynamic>);
      }).toList();
    });
  }

  Future<void> addTodo(Todo todo) async {
    await _database.child(todo.id).set(todo.toJson());
  }

  Future<void> updateTodo(String id, Map<String, dynamic> updates) async {
    await _database.child(id).update(updates);
  }

  Future<void> deleteTodo(String id) async {
    await _database.child(id).remove();
  }
}