import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/todo.dart';

class FirebaseService {
  DatabaseReference get _database {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw FirebaseException(
        plugin: 'firebase_auth',
        message: 'No authenticated user. Please sign in before accessing data.',
      );
    }
    return FirebaseDatabase.instance.ref('users/${user.uid}/todos');
  }

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