import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_screen.dart';
import 'workout_screen.dart';
import 'calorie_screen.dart';
import 'progress_screen.dart';
import 'routine_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({required this.toggleTheme, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(onNavigate: _onTabSelected),
      WorkoutScreen(),
      CalorieScreen(),
      ProgressScreen(),
      RoutineScreen(),
    ];
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  final List<String> _titles = [
    'Dashboard',
    'Workout Log',
    'Calorie Tracker',
    'Progress',
    'Routines',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.tealAccent.withOpacity(0.2),
        centerTitle: true,
        title: Text(
          _titles[_currentIndex],
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode, color: Colors.white),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Colors.tealAccent,
            unselectedItemColor: Colors.grey.shade400,
            backgroundColor: const Color(0xFF0f2027),
            type: BottomNavigationBarType.fixed,
            onTap: _onTabSelected,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.fitness_center_rounded), label: 'Workout'),
              BottomNavigationBarItem(icon: Icon(Icons.fastfood_rounded), label: 'Calories'),
              BottomNavigationBarItem(icon: Icon(Icons.show_chart_rounded), label: 'Progress'),
              BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Routines'),
            ],
          ),
        ),
      ),
    );
  }
}
