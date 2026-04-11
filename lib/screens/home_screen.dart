import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/firebase_service.dart';
import '../widgets/todo_item.dart';
import 'add_todo_dialog.dart';

class HomeScreen extends StatefulWidget {                   // Stateful Widget as UI Changes regularly
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // Creates an instance of FirebaseService for database operations
  final FirebaseService _firebaseService = FirebaseService();

  void _showAddTodoDialog(BuildContext context) {            // Method to show a DialogBox
    showDialog(                                              // Shows a dialog using Flutter's showDialog
      context: context,
      builder: (context) => AddTodoDialog(                   // Building a AddToDoWidget
        onAdd: (title, dueDate) async {
          final newTodo = Todo(                              // Creating a new ToDo item
            id: DateTime.now().millisecondsSinceEpoch.toString(),     // Unique ID using current time
            title: title,
            dueDate: dueDate.millisecondsSinceEpoch,
            isCompleted: false,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          );
          await _firebaseService.addTodo(newTodo);           // Saving the Todo in the Firebase.
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(                                        // AppBar for the App
        backgroundColor: Colors.black,
        title: const Text(
          'Todo App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [                                           // Action Button on the AppBar
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddTodoDialog(context),    // context passed in the showAddToDoDialogBox
          ),
        ],
      ),
      body: StreamBuilder<List<Todo>>(                       // ***** StreamBuilder to listen to real-time Firebase data
        stream: _firebaseService.getTodos(),                 // Getting the Current Todos
        builder: (context, snapshot) {                       // Builder function rebuilds UI when data changes
          if (snapshot.connectionState == ConnectionState.waiting) {         // shows loading spinner for the data
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {                           // Error message for the errors
            return Center(
              child: Text(
                'Error: ${snapshot.error}',                  // whatever the error is
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final todos = snapshot.data ?? [];                 // Either ToDos or empty list

          // Sort todos: pending first (earliest due date first), then completed (oldest created first)
          final pending = todos
              .where((todo) => !todo.isCompleted)
              .toList()
            ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

          final completed = todos
              .where((todo) => todo.isCompleted)
              .toList()
            ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

          final sortedTodos = [...pending, ...completed];        // Combine the above two ToDo Lists

          if (sortedTodos.isEmpty) {                             // When we don't have any ToDos
            return const Center(
              child: Text(
                'No todos yet. Add one!',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(                               // Creates a Scrollable List
            itemCount: sortedTodos.length,                       // Total ToDos
            // For each item, creates a TodoItem widget with the todo data and Firebase service
            itemBuilder: (context, index) {
              final todo = sortedTodos[index];                   // Particular ToDo
              return TodoItem(
                todo: todo,
                firebaseService: _firebaseService,
              );
            },
          );
        },
      ),
    );
  }
}