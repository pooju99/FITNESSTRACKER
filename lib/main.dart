import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {
  bool _isDark = false; // default to light mode for better look

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: _isDark
          ? ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.teal,
                secondary: Colors.greenAccent,
              ),
            )
          : ThemeData.light(useMaterial3: true).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.teal,
                secondary: Colors.greenAccent,
              ),
            ),
      home: HomeScreen(toggleTheme: _toggleTheme),
    );
  }
}
