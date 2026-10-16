import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_task_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final String? savedName = prefs.getString('userName');
  final bool isLoggedIn = savedName != null && savedName.trim().isNotEmpty;

  runApp(TudeeApp(isLoggedIn: isLoggedIn));
}

class TudeeApp extends StatelessWidget {
  final bool isLoggedIn;

  const TudeeApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tudee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF0EC),
        primaryColor: const Color(0xFF38B4EE),
      ),
      initialRoute: isLoggedIn ? '/home' : '/welcome',
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-task': (context) => AddTaskScreen(),
      },
    );
  }
}
