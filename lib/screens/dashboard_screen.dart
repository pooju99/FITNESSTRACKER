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
  double goalProgress = 0.6;

  final List<String> quotes = [
    "No pain, no gain!",
    "Push yourself, no one else will do it for you.",
    "Success starts with self-discipline.",
    "Train insane or remain the same.",
    "Your body can stand almost anything; it’s your mind you have to convince."
  ];

  late String dailyQuote;

  @override
  void initState() {
    super.initState();
    _loadData();
    dailyQuote = quotes[DateTime.now().day % quotes.length];
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final workouts = prefs.getString('workouts');
    final calories = prefs.getString('calories');
    if (workouts != null) {
      totalWorkouts =
          List<Map<String, dynamic>>.from(json.decode(workouts)).length;
    }
    if (calories != null) {
      final list = List<Map<String, dynamic>>.from(json.decode(calories));
      totalCalories =
          list.fold(0, (sum, e) => sum + int.tryParse(e['calories'] ?? '0')!);
    }
    setState(() {});
  }

  BoxDecoration _glassCard() {
    return BoxDecoration(
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
  }

  Widget _metricCard(String title, String value, IconData icon) {
    return Container(
      width: 150,
      height: 150,
      decoration: _glassCard(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.tealAccent, size: 35),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(title, style: GoogleFonts.poppins(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _goalProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _glassCard(),
      child: Column(
        children: [
          Text(
            "Next Goal",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: goalProgress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.white.withOpacity(0.2),
            color: Colors.tealAccent,
          ),
          const SizedBox(height: 8),
          Text(
            "${(goalProgress * 100).toStringAsFixed(0)}% Complete",
            style: GoogleFonts.poppins(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
      String label, IconData icon, int tabIndex, Color color) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.9),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
      ),
      onPressed: () => widget.onNavigate(tabIndex),
    );
  }

  Widget _motivationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _glassCard(),
      child: Column(
        children: [
          Text(
            "💪 Motivation of the Day",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.tealAccent),
          ),
          const SizedBox(height: 10),
          Text(
            '"$dailyQuote"',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Fitness Dashboard",
                  style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent),
                ),
                const SizedBox(height: 30),

                /// Metrics
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _metricCard("Workouts", "$totalWorkouts",
                        Icons.fitness_center_rounded),
                    _metricCard("Calories", "$totalCalories kcal",
                        Icons.local_fire_department_rounded),
                  ],
                ),
                const SizedBox(height: 30),

                _goalProgressCard(),
                const SizedBox(height: 25),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _actionButton("Add Workout", Icons.add_circle_outline, 1,
                        Colors.tealAccent),
                    _actionButton("Track Calories", Icons.fastfood_outlined, 2,
                        Colors.orangeAccent),
                    _actionButton(
                        "View Progress", Icons.show_chart, 3, Colors.blueAccent),
                  ],
                ),
                const SizedBox(height: 35),

                _motivationCard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
