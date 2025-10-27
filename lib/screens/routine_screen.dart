import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  List<Map<String, String>> customRoutines = [];

  // 🏋️ Default non-editable preset routines
  final List<Map<String, String>> presetRoutines = [
    {
      'name': 'Beginner Routine',
      'description': '• 10 Pushups\n• 15 Squats\n• 5-min Jog\n• 10 Sit-ups',
    },
    {
      'name': 'Intermediate Routine',
      'description':
          '• 20 Pushups\n• 25 Squats\n• 10-min Run\n• 15 Sit-ups\n• 10 Burpees',
    },
    {
      'name': 'Advanced Routine',
      'description':
          '• 30 Pushups\n• 40 Squats\n• 15-min Run\n• 20 Sit-ups\n• 15 Burpees\n• 10 Pull-ups',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomRoutines();
  }

  /// 🧠 Load saved custom routines
  Future<void> _loadCustomRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('custom_routines');
    if (data != null) {
      setState(() =>
          customRoutines = List<Map<String, String>>.from(json.decode(data)));
    }
  }

  /// 💾 Save routines
  Future<void> _saveCustomRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_routines', json.encode(customRoutines));
  }

  /// ➕ Add new custom routine
  void _addRoutine() {
    if (_nameController.text.isEmpty || _descController.text.isEmpty) return;

    setState(() {
      customRoutines.add({
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
      });
    });
    _saveCustomRoutines();

    _nameController.clear();
    _descController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Routine added!"),
        backgroundColor: Colors.tealAccent,
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// ✏️ Edit existing routine
  void _editRoutine(int index) {
    _nameController.text = customRoutines[index]['name'] ?? '';
    _descController.text = customRoutines[index]['description'] ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text("Edit Routine",
            style: GoogleFonts.poppins(color: Colors.tealAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Routine Name",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Description",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nameController.clear();
              _descController.clear();
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                customRoutines[index]['name'] = _nameController.text.trim();
                customRoutines[index]['description'] =
                    _descController.text.trim();
              });
              _saveCustomRoutines();
              _nameController.clear();
              _descController.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("💪 Routine updated!"),
                  backgroundColor: Colors.blueAccent,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text("Save", style: TextStyle(color: Colors.tealAccent)),
          ),
        ],
      ),
    );
  }

  /// ❌ Delete routine
  void _deleteRoutine(int index) async {
    setState(() => customRoutines.removeAt(index));
    await _saveCustomRoutines();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🗑️ Routine deleted."),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  /// 💡 Pro Fitness Tips
  void _showFitnessTips(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.tealAccent.withOpacity(0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("🏋️‍♂️ Pro Fitness Tips",
                  style: GoogleFonts.poppins(
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
              const SizedBox(height: 15),
              ...[
                "🔥 Warm up before every workout",
                "🥗 Eat a balanced diet with protein",
                "💧 Stay hydrated daily",
                "🕒 Sleep 7–8 hours for recovery",
                "📅 Track your progress weekly",
              ].map(
                (tip) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(tip,
                      style: GoogleFonts.poppins(
                          color: Colors.white70, fontSize: 15),
                      textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(scale: anim, child: child);
      },
    );
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
    final allRoutines = [...presetRoutines, ...customRoutines];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Workout Routines",
                      style: GoogleFonts.poppins(
                          color: Colors.tealAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.lightbulb_outline,
                        color: Colors.tealAccent),
                    onPressed: () => _showFitnessTips(context),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Add form
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Custom Routine Name", Icons.add),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Description", Icons.description),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Routine"),
                onPressed: _addRoutine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 25),

              Expanded(
                child: allRoutines.isEmpty
                    ? Center(
                        child: Text("No routines available",
                            style: GoogleFonts.poppins(
                                color: Colors.white54, fontSize: 16)))
                    : RefreshIndicator(
                        onRefresh: _loadCustomRoutines,
                        child: ListView.builder(
                          itemCount: allRoutines.length,
                          itemBuilder: (context, index) {
                            final routine = allRoutines[index];
                            final isPreset = index < presetRoutines.length;
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: _glassCard(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(routine['name'] ?? '',
                                          style: GoogleFonts.poppins(
                                              color: Colors.tealAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      if (!isPreset)
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.blueAccent),
                                              onPressed: () =>
                                                  _editRoutine(index -
                                                      presetRoutines.length),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.redAccent),
                                              onPressed: () => _deleteRoutine(
                                                  index -
                                                      presetRoutines.length),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    routine['description'] ?? '',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white70, fontSize: 14),
                                  ),
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
