import 'package:flutter/material.dart';
import '../database/firestore_service.dart';
import '../database/todo.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class EditTaskScreen extends StatefulWidget {
  final Todo task;

  const EditTaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final FirestoreService firestoreService = FirestoreService();
  late TextEditingController _titleController;
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _isDone = widget.task.isComplete;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    final updatedTitle = _titleController.text.trim();
    if (updatedTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a task title'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final updatedTask = Todo(
      id: widget.task.id,
      title: updatedTitle,
      isComplete: _isDone,
    );

    await firestoreService.updateTask(updatedTask);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  void _deleteTask() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await firestoreService.deleteTask(widget.task.id);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF0EC),
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Task',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                  tooltip: 'Delete Task',
                  onPressed: _deleteTask,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Task Title',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            CustomTextField(
              controller: _titleController,
              hintText: 'What needs to be done?',
            ),
            SizedBox(height: 20),
            Text(
              'Status',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _isDone
                              ? Color(0xFF6CBF84)
                              : Color(0xFF8A7CF7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _isDone ? 'Completed' : 'To-Do',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        _isDone ? 'Marked as Done' : 'Pending',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isDone,
                    activeThumbColor: Color(0xFF6CBF84),
                    onChanged: (val) {
                      setState(() {
                        _isDone = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            CustomButton(
              text: 'Save Changes',
              onPressed: _saveTask,
            ),
          ],
        ),
      ),
    );
  }
}
