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
  List<Map<String, String>> workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('workouts');
    if (data != null) {
      setState(() => workouts = List<Map<String, String>>.from(json.decode(data)));
    }
  }

  Future<void> _saveWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('workouts', json.encode(workouts));
  }

  void _addWorkout() {
    if (_nameController.text.isNotEmpty && _durationController.text.isNotEmpty) {
      setState(() {
        workouts.add({
          'name': _nameController.text,
          'duration': _durationController.text,
        });
      });
      _saveWorkouts();
      _nameController.clear();
      _durationController.clear();
    }
  }

  void _deleteWorkout(int index) async {
    setState(() => workouts.removeAt(index));
    _saveWorkouts();
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
              Text(
                "Add New Workout",
                style: GoogleFonts.poppins(
                    color: Colors.tealAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Inputs
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
                    : ListView.builder(
                        itemCount: workouts.length,
                        itemBuilder: (context, index) {
                          final item = workouts[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: _glassCard(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item['name']!,
                                          style: GoogleFonts.poppins(
                                              color: Colors.tealAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      Text("${item['duration']} mins",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white70)),
                                    ]),
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
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.tealAccent),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.tealAccent),
      ),
    );
  }
}
