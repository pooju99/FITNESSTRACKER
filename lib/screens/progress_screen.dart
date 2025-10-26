import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text("Progress Overview",
                  style: GoogleFonts.poppins(
                      color: Colors.tealAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: LineChart(LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: true),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: [
                          FlSpot(0, 2),
                          FlSpot(1, 3),
                          FlSpot(2, 4),
                          FlSpot(3, 3.5),
                          FlSpot(4, 4.5),
                          FlSpot(5, 5),
                          FlSpot(6, 6),
                        ],
                        color: Colors.tealAccent,
                        dotData: const FlDotData(show: true),
                      )
                    ],
                  )),
                ),
              ),
              const SizedBox(height: 30),
              Text("BMI Calculator",
                  style: GoogleFonts.poppins(
                      color: Colors.tealAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _bmiInput("Height (cm)", Icons.height),
              const SizedBox(height: 10),
              _bmiInput("Weight (kg)", Icons.fitness_center),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Calculate BMI"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bmiInput(String hint, IconData icon) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
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
      ),
      keyboardType: TextInputType.number,
    );
  }
}
