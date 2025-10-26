import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CalorieScreen extends StatefulWidget {
  const CalorieScreen({super.key});

  @override
  State<CalorieScreen> createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  List<Map<String, String>> calorieList = [];

  @override
  void initState() {
    super.initState();
    _loadCalories();
  }

  Future<void> _loadCalories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('calories');
    if (data != null) {
      setState(() => calorieList = List<Map<String, String>>.from(json.decode(data)));
    }
  }

  Future<void> _saveCalories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('calories', json.encode(calorieList));
  }

  void _addEntry() {
    if (_itemController.text.isNotEmpty && _calorieController.text.isNotEmpty) {
      setState(() {
        calorieList.add({
          'item': _itemController.text,
          'calories': _calorieController.text,
        });
      });
      _saveCalories();
      _itemController.clear();
      _calorieController.clear();
    }
  }

  void _deleteEntry(int index) {
    setState(() => calorieList.removeAt(index));
    _saveCalories();
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
              Text("Calorie Tracker",
                  style: GoogleFonts.poppins(
                      color: Colors.tealAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              TextField(
                controller: _itemController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Food Item", Icons.restaurant),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _calorieController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Calories", Icons.local_fire_department),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 15),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Entry"),
                onPressed: _addEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),

              const SizedBox(height: 25),
              Expanded(
                child: calorieList.isEmpty
                    ? Center(
                        child: Text("No entries yet",
                            style: GoogleFonts.poppins(
                                color: Colors.white54, fontSize: 16)))
                    : ListView.builder(
                        itemCount: calorieList.length,
                        itemBuilder: (context, index) {
                          final item = calorieList[index];
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
                                      Text(item['item']!,
                                          style: GoogleFonts.poppins(
                                              color: Colors.orangeAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      Text("${item['calories']} kcal",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white70)),
                                    ]),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.redAccent),
                                  onPressed: () => _deleteEntry(index),
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
      prefixIcon: Icon(icon, color: Colors.orangeAccent),
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
        borderSide: const BorderSide(color: Colors.orangeAccent),
      ),
    );
  }
}
