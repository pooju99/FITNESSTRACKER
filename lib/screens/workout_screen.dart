import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  List<Map<String, String>> workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  /// 🧠 Load saved workouts
  Future<void> _loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('workouts');
    if (data != null) {
      setState(() => workouts = List<Map<String, String>>.from(json.decode(data)));
    }
  }

  /// 💾 Save workouts
  Future<void> _saveWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('workouts', json.encode(workouts));
  }

  /// 🔥 Update streak when user adds a new workout
  Future<void> _updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final lastDateString = prefs.getString('last_active_date');
    int streak = prefs.getInt('workout_streak') ?? 0;

    if (lastDateString != null) {
      final lastDate = DateTime.parse(lastDateString);
      final diff = today.difference(lastDate).inDays;

      if (diff == 1) {
        streak++;
      } else if (diff > 1) {
        streak = 1;
      }
    } else {
      streak = 1;
    }

    await prefs.setInt('workout_streak', streak);
    await prefs.setString('last_active_date', today.toIso8601String());
  }

  /// ➕ Add workout
  Future<void> _addWorkout() async {
    if (_nameController.text.isNotEmpty && _durationController.text.isNotEmpty) {
      setState(() {
        workouts.add({
          'name': _nameController.text.trim(),
          'duration': _durationController.text.trim(),
          'calories': _calorieController.text.trim(),
        });
      });
      await _saveWorkouts();
      await _updateStreak();

      _nameController.clear();
      _durationController.clear();
      _calorieController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("💪 Workout added successfully!"),
          backgroundColor: Colors.tealAccent,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  /// ❌ Delete workout
  void _deleteWorkout(int index) async {
    setState(() => workouts.removeAt(index));
    await _saveWorkouts();
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text("Add New Workout",
                  style: GoogleFonts.poppins(
                      color: Colors.tealAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Workout Name", Icons.fitness_center),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _durationController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Duration (min)", Icons.timer),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _calorieController,
                style: const TextStyle(color: Colors.white),
                decoration:
                    _inputDecoration("Calories Burned", Icons.local_fire_department),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Workout"),
                onPressed: _addWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: workouts.isEmpty
                    ? Center(
                        child: Text("No workouts added yet",
                            style: GoogleFonts.poppins(
                                color: Colors.white54, fontSize: 16)))
                    : RefreshIndicator(
                        onRefresh: _loadWorkouts,
                        child: ListView.builder(
                          itemCount: workouts.length,
                          itemBuilder: (context, index) {
                            final item = workouts[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: _glassCard(),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['name'] ?? '',
                                          style: GoogleFonts.poppins(
                                              color: Colors.tealAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      Text("${item['duration']} mins",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white70)),
                                      if (item['calories'] != null &&
                                          item['calories']!.isNotEmpty)
                                        Text("${item['calories']} kcal",
                                            style: GoogleFonts.poppins(
                                                color: Colors.orangeAccent,
                                                fontSize: 13)),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.redAccent),
                                    onPressed: () => _deleteWorkout(index),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) =>
      InputDecoration(
        prefixIcon: Icon(icon, color: Colors.tealAccent),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.tealAccent),
        ),
      );
}
