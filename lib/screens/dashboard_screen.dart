import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  final Function(int) onNavigate;
  const DashboardScreen({required this.onNavigate, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalWorkouts = 0;
  int totalCalories = 0;
  int totalRoutines = 0;
  int streak = 0;
  double? lastBMI;
  String bmiCategory = '';
  late String dailyQuote;

  final List<String> quotes = [
    "No pain, no gain!",
    "Push yourself, no one else will do it for you.",
    "Success starts with self-discipline.",
    "Train insane or remain the same.",
    "Your body can stand almost anything; it’s your mind you have to convince."
  ];

  @override
  void initState() {
    super.initState();
    dailyQuote = quotes[DateTime.now().day % quotes.length];
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData(); // Auto refresh when returning to Dashboard
  }

  /// 🧠 Load everything from SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // --- Workouts ---
    final workouts = prefs.getString('workouts');
    if (workouts != null) {
      totalWorkouts =
          List<Map<String, dynamic>>.from(json.decode(workouts)).length;
    }

    // --- Calories ---
    final calories = prefs.getString('calories');
    if (calories != null) {
      final list = List<Map<String, dynamic>>.from(json.decode(calories));
      totalCalories =
          list.fold(0, (sum, e) => sum + int.tryParse(e['calories'] ?? '0')!);
    }

    // --- Routines (Default + User Added) ---
    final routinesData = prefs.getString('routines');
    if (routinesData != null && routinesData.isNotEmpty) {
      final decoded = json.decode(routinesData);
      if (decoded is List) {
        totalRoutines = decoded.length;
      }
    } else {
      totalRoutines = 3; // Default 3 presets (Beginner, Intermediate, Advanced)
    }

    // --- BMI ---
    lastBMI = prefs.getDouble('bmi_result');
    bmiCategory = prefs.getString('bmi_category') ?? '';

    // --- Streak Tracker ---
    DateTime today = DateTime.now();
    String lastWorkoutDate = prefs.getString('last_workout_date') ?? '';
    streak = prefs.getInt('workout_streak') ?? 0;

    if (lastWorkoutDate.isNotEmpty) {
      DateTime lastDate = DateTime.parse(lastWorkoutDate);
      if (today.difference(lastDate).inDays == 1) {
        streak++; // continued streak
      } else if (today.difference(lastDate).inDays > 1) {
        streak = 0; // reset streak
      }
    }

    await prefs.setString('last_workout_date', today.toIso8601String());
    await prefs.setInt('workout_streak', streak);

    setState(() {});
  }

  BoxDecoration _glassCard() => BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      );

  Widget _metricCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 150,
      height: 150,
      decoration: _glassCard(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 10),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(title, style: GoogleFonts.poppins(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _streakCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _glassCard(),
      child: Column(
        children: [
          Text("🔥 Streak Tracker",
              style: GoogleFonts.poppins(
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          const SizedBox(height: 10),
          Text(
            streak > 0
                ? "You're on a $streak-day streak! Keep going 💪"
                : "Start your streak today!",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _goalProgressCard() {
    final goalProgress = (totalWorkouts / 10).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _glassCard(),
      child: Column(
        children: [
          Text("Next Goal",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: goalProgress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.white.withOpacity(0.2),
            color: Colors.tealAccent,
          ),
          const SizedBox(height: 8),
          Text("${(goalProgress * 100).toStringAsFixed(0)}% Complete",
              style: GoogleFonts.poppins(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _bmiCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: _glassCard(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("BMI Summary",
                style: GoogleFonts.poppins(
                    color: Colors.tealAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            lastBMI != null
                ? Column(
                    children: [
                      Text("${lastBMI!.toStringAsFixed(1)}",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      Text(bmiCategory,
                          style: GoogleFonts.poppins(
                              color: Colors.orangeAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ],
                  )
                : Text("No BMI data yet",
                    style: GoogleFonts.poppins(
                        color: Colors.white54, fontSize: 14)),
          ],
        ),
      );

  Widget _motivationCard() => Container(
        padding: const EdgeInsets.all(18),
        decoration: _glassCard(),
        child: Column(
          children: [
            Text("💪 Motivation of the Day",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.tealAccent)),
            const SizedBox(height: 10),
            Text('"$dailyQuote"',
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.poppins(fontSize: 15, color: Colors.white70)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text("Fitness Dashboard",
                      style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent)),
                  const SizedBox(height: 30),

                  // Metrics
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _metricCard("Workouts", "$totalWorkouts",
                          Icons.fitness_center_rounded, Colors.tealAccent),
                      _metricCard("Calories", "$totalCalories kcal",
                          Icons.local_fire_department, Colors.orangeAccent),
                      _metricCard("Routines", "$totalRoutines",
                          Icons.list_alt_rounded, Colors.blueAccent),
                    ],
                  ),

                  const SizedBox(height: 30),
                  _streakCard(),
                  const SizedBox(height: 20),
                  _bmiCard(),
                  const SizedBox(height: 25),
                  _goalProgressCard(),
                  const SizedBox(height: 25),
                  _motivationCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
