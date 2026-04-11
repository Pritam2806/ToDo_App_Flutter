import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../services/firebase_service.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.todo, required this.firebaseService});

  final Todo todo;                                           // Our ToDo item to be displayed.
  final FirebaseService firebaseService;

  @override
  Widget build(BuildContext context) {
    final dueDate = DateTime.fromMillisecondsSinceEpoch(todo.dueDate);
    final formattedDate = DateFormat('dd/MM/yyyy').format(dueDate);      // Converting to our required format.

    return Dismissible(                                                  // Only Dismissable used.
      key: Key(todo.id),                                                 // Storing what to be deleted.
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.black,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        final deletedTodo = todo;                                       // ToDo that will be deleted

        final snackBar = SnackBar(
          content: const Text('Task deleted'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () async {
              await firebaseService.addTodo(deletedTodo);             // Performing the addition on pressing UNDO
            },
          ),
        );

        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(snackBar);

        // Auto-hide the SnackBar after 5 seconds
        Timer(const Duration(seconds: 5), () {
          messenger.hideCurrentSnackBar();
        });

        // Perform deletion without awaiting to avoid BuildContext across async gap
        firebaseService.deleteTodo(todo.id);                            // Delete the ToDo from firebase
      },
      child: Card(
        color: const Color(0xFF121212),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListTile(
          leading: Checkbox(                                            // Leading will be a Checkbox.
            value: todo.isCompleted,                                    // Check or Uncheck
            onChanged: (value) async {
              final now = DateTime.now().millisecondsSinceEpoch;        // Getting the current time
              await firebaseService.updateTodo(todo.id, {
                'isCompleted': value,                                   // Map data structure
                'completedAt': value == true ? now : null,              // Time of completion of the task
              });
            },
            activeColor: Colors.white,
            checkColor: Colors.black,
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              color: todo.isCompleted ? Colors.grey : Colors.white,
              fontWeight: FontWeight.bold,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,      // Line on the item
            ),
          ),
          trailing: Text(                                           // Trailing means at the right end of the list-tile
            formattedDate,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}