import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Workout Routines",
                  style: GoogleFonts.poppins(
                    color: Colors.tealAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                /// --- EXPANSION PANELS ---
                _routineTile(
                  "Beginner",
                  [
                    "• 10 Pushups",
                    "• 15 Squats",
                    "• 5-min Jog",
                    "• 10 Sit-ups",
                  ],
                ),
                _routineTile(
                  "Intermediate",
                  [
                    "• 20 Pushups",
                    "• 25 Squats",
                    "• 10-min Run",
                    "• 15 Sit-ups",
                    "• 10 Burpees",
                  ],
                ),
                _routineTile(
                  "Advanced",
                  [
                    "• 30 Pushups",
                    "• 40 Squats",
                    "• 15-min Run",
                    "• 20 Sit-ups",
                    "• 15 Burpees",
                    "• 10 Pull-ups",
                  ],
                ),

                const SizedBox(height: 30),

                /// --- MOTIVATION CARD ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _glassCard(),
                  child: Column(
                    children: [
                      Text(
                        "💡 Stay Consistent!",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Consistency beats intensity — small progress every day builds habits that last!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// --- VIEW TIPS BUTTON ---
                ElevatedButton.icon(
                  onPressed: () => _showFitnessTips(context),
                  icon: const Icon(Icons.lightbulb_outline, color: Colors.white),
                  label: Text(
                    "View Fitness Tips",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _routineTile(String title, List<String> exercises) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: _glassCard(),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedTextColor: Colors.tealAccent,
          collapsedIconColor: Colors.tealAccent,
          textColor: Colors.tealAccent,
          iconColor: Colors.tealAccent,
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
              fontSize: 16,
            ),
          ),
          children: exercises
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: Colors.white54, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        e,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showFitnessTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black.withOpacity(0.8),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "🏋️‍♂️ Pro Fitness Tips",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                    fontSize: 20),
              ),
              const SizedBox(height: 15),
              ...[
                "🔥 Warm up before every workout",
                "🥗 Maintain a balanced diet",
                "💧 Stay hydrated",
                "🕒 Get 7–8 hours of sleep",
                "📆 Track your progress weekly",
              ].map((tip) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      tip,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
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
    );
  }
}
