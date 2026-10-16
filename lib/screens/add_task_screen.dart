import 'package:flutter/material.dart';
import '../database/firestore_service.dart';
import '../database/todo.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final TextEditingController taskController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF0EC),
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Task',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: taskController,
              hintText: 'What needs to be done?',
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Save',
              onPressed: () async {
                String text = taskController.text.trim();
                if (text.isNotEmpty) {
                  final newTodo = Todo(
                    title: text,
                    isComplete: false,
                  );
                  await firestoreService.addTask(newTodo);
                  if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a task title'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
