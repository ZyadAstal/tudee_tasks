import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/firestore_service.dart';
import '../database/todo.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/status_card.dart';
import '../widgets/task_item_card.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService = FirestoreService();
  String name = 'Zyad';

  @override
  void initState() {
    super.initState();
    loadSavedName();
  }

  void loadSavedName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('userName') ?? 'Zyad';
    });
  }

  void _navigateToEditTask(Todo task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    );
  }

  void _toggleTask(Todo task) async {
    final updated = Todo(
      id: task.id,
      title: task.title,
      isComplete: !task.isComplete,
    );
    await firestoreService.updateTask(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF0EC),
      appBar: CustomAppBar(),
      body: StreamBuilder<List<Todo>>(
        stream: firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF38B4EE)),
            );
          }

          final tasks = snapshot.data ?? [];
          final int doneCount = tasks.where((t) => t.isComplete).length;
          final int todoCount = tasks.where((t) => !t.isComplete).length;

          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              // Header Card with Welcome & Stats
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome $name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        StatusCard(
                          title: 'Done',
                          count: doneCount,
                          color: Color(0xFF6CBF84),
                        ),
                        SizedBox(width: 12),
                        StatusCard(
                          title: 'To-Do',
                          count: todoCount,
                          color: Color(0xFF8A7CF7),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Tasks List or Empty State
              if (tasks.isEmpty)
                Container(
                  height: 180,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 48,
                          color: Colors.grey[350],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'No tasks for today!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Tap the + button to add your first one.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                for (int i = 0; i < tasks.length; i++)
                  TaskItemCard(
                    task: tasks[i],
                    onTap: () {
                      _toggleTask(tasks[i]);
                    },
                    onEdit: () {
                      _navigateToEditTask(tasks[i]);
                    },
                  ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF38B4EE),
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
        child: Icon(
          Icons.note_add,
          color: Colors.white,
        ),
      ),
    );
  }
}
