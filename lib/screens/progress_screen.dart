import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:convert';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? _bmiResult;
  String _bmiCategory = '';
  List<double> _bmiHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSavedBMI();
  }

  /// 🧠 Load saved BMI + history
  Future<void> _loadSavedBMI() async {
    final prefs = await SharedPreferences.getInstance();
    final height = prefs.getString('bmi_height');
    final weight = prefs.getString('bmi_weight');
    final result = prefs.getDouble('bmi_result');
    final category = prefs.getString('bmi_category');
    final history = prefs.getString('bmi_history');

    setState(() {
      if (height != null) _heightController.text = height;
      if (weight != null) _weightController.text = weight;
      _bmiResult = result;
      _bmiCategory = category ?? '';
      if (history != null) {
        _bmiHistory = List<double>.from(json.decode(history));
      }
    });
  }

  /// 💾 Save BMI + update history
  Future<void> _saveBMI(double bmi, String category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bmi_height', _heightController.text);
    await prefs.setString('bmi_weight', _weightController.text);
    await prefs.setDouble('bmi_result', bmi);
    await prefs.setString('bmi_category', category);

    // Save last 5 BMI values
    _bmiHistory.add(bmi);
    if (_bmiHistory.length > 5) _bmiHistory.removeAt(0);
    await prefs.setString('bmi_history', json.encode(_bmiHistory));
  }

  /// 🧮 Calculate BMI
  void _calculateBMI() {
    final double? heightCm = double.tryParse(_heightController.text);
    final double? weightKg = double.tryParse(_weightController.text);

    if (heightCm == null || weightKg == null || heightCm <= 0 || weightKg <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please enter valid height and weight."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final double heightM = heightCm / 100;
    final double bmi = weightKg / pow(heightM, 2);

    String category;
    if (bmi < 18.5) {
      category = 'Underweight';
    } else if (bmi < 25) {
      category = 'Normal weight';
    } else if (bmi < 30) {
      category = 'Overweight';
    } else {
      category = 'Obese';
    }

    setState(() {
      _bmiResult = bmi;
      _bmiCategory = category;
    });

    _saveBMI(bmi, category);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ BMI calculated and saved!"),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// 🧹 Clear BMI data
  Future<void> _clearBMI() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bmi_result');
    await prefs.remove('bmi_category');
    await prefs.remove('bmi_history');

    setState(() {
      _bmiResult = null;
      _bmiCategory = '';
      _bmiHistory.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🗑️ BMI history cleared!"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spots = _bmiHistory.isNotEmpty
        ? _bmiHistory.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value);
          }).toList()
        : [
            const FlSpot(0, 0),
          ];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Progress & BMI Tracker",
                      style: GoogleFonts.poppins(
                          color: Colors.tealAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.redAccent),
                    tooltip: "Clear BMI Data",
                    onPressed: _bmiHistory.isNotEmpty ? _clearBMI : null,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 📈 BMI History Chart
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 40,
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: true),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          spots: spots,
                          color: Colors.tealAccent,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- 🧮 BMI Calculator ---
              Text("BMI Calculator",
                  style: GoogleFonts.poppins(
                      color: Colors.tealAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              _bmiInput("Height (cm)", Icons.height, _heightController),
              const SizedBox(height: 10),
              _bmiInput("Weight (kg)", Icons.monitor_weight, _weightController),

              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Calculate BMI"),
              ),

              const SizedBox(height: 25),

              if (_bmiResult != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(15),
                    border:
                        Border.all(color: Colors.tealAccent.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Your BMI: ${_bmiResult!.toStringAsFixed(1)}",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _bmiCategory,
                        style: GoogleFonts.poppins(
                            color: Colors.tealAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bmiInput(
      String hint, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
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
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.tealAccent),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
