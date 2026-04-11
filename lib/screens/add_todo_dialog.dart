import 'package:flutter/material.dart';

class AddTodoDialog extends StatefulWidget {                             // Stateful Widget.
  const AddTodoDialog({super.key, required this.onAdd});

  final Function(String title, DateTime dueDate) onAdd;

  @override
  State<AddTodoDialog> createState() {
    return _AddTodoDialogState();
  }
}

class _AddTodoDialogState extends State<AddTodoDialog> {                 
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {            // Async Function                     
    final DateTime? picked = await showDatePicker(                  // Selecting the date from DatePicker.
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;                                     // Setting the state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(                                             // Alert DialogBox
      backgroundColor: const Color(0xFF121212),
      title: const Text(
        'Add Todo',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Task Title',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Due Date: ',
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.trim().isNotEmpty) {
              widget.onAdd(_titleController.text.trim(), _selectedDate);      // "onAdd" function in widget defination
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}