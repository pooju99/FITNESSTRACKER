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
  int _selectedIndex = 0;

  // Define all screens
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(onNavigate: _navigateToTab),
      const WorkoutScreen(),
      const CalorieScreen(),
      const ProgressScreen(),
      const RoutineScreen(),
    ];
  }

  /// 🌐 Switch between screens
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  /// 🔁 Dashboard navigation helper (e.g., "Add Workout" button)
  void _navigateToTab(int tabIndex) {
    setState(() => _selectedIndex = tabIndex);
  }

  /// 💡 Nice transition effect between screens
  Widget _buildAnimatedBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _screens[_selectedIndex],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _buildAnimatedBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.tealAccent,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded), label: "Dashboard"),
            BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center_rounded), label: "Workout"),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_fire_department_rounded),
                label: "Calories"),
            BottomNavigationBarItem(
                icon: Icon(Icons.show_chart_rounded), label: "Progress"),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded), label: "Routines"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.toggleTheme,
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
        child: const Icon(Icons.brightness_6),
        tooltip: "Toggle Theme",
      ),
    );
  }
}
