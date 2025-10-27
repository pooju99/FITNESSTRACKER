import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';

/// 🔔 Local Notifications setup (for Android/iOS only)
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);
  await notificationsPlugin.initialize(initSettings);
}

/// ⏰ Schedule a daily workout reminder (mobile only)
Future<void> scheduleDailyReminder() async {
  await notificationsPlugin.zonedSchedule(
    0,
    '🏋️ Time to Move!',
    'Don’t forget your workout today 💪',
    tz.TZDateTime.now(tz.local).add(const Duration(hours: 24)),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel',
        'Daily Workout Reminder',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

/// 🧠 Browser in-app popup reminder (for Web)
Future<void> showWebReminder(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final lastPrompt = prefs.getString('lastReminder');
  final now = DateTime.now();

  if (lastPrompt == null ||
      DateTime.parse(lastPrompt).day != now.day) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("🏋️ Daily Reminder"),
          content: const Text("Don’t forget your workout today 💪"),
          actions: [
            TextButton(
              child: const Text("Let's Go!"),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      );
    });
    await prefs.setString('lastReminder', now.toIso8601String());
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  if (!kIsWeb) {
    // 🧱 Mobile platforms: real notifications
    await initNotifications();
    await scheduleDailyReminder();
  }

  runApp(const FitnessApp());
}

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🧩 Trigger web reminder only on browser
    if (kIsWeb) {
      showWebReminder(context);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: _isDark
          ? ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.teal,
                secondary: Colors.greenAccent,
              ),
            )
          : ThemeData.light(useMaterial3: true).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.teal,
                secondary: Colors.greenAccent,
              ),
            ),
      home: HomeScreen(toggleTheme: _toggleTheme),
    );
  }
}
