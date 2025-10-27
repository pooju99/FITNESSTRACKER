import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = "fitness_tracker.db";
  static const _dbVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Workouts table
    await db.execute('''
      CREATE TABLE workouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        duration TEXT NOT NULL
      )
    ''');

    // Calories table
    await db.execute('''
      CREATE TABLE calories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item TEXT NOT NULL,
        calories TEXT NOT NULL
      )
    ''');

    // Routines table
    await db.execute('''
      CREATE TABLE routines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        day TEXT,
        time TEXT
      )
    ''');

    // Progress table
    await db.execute('''
      CREATE TABLE progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        weight REAL NOT NULL,
        bmi REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  // ---------- 🏋️ Workouts ----------
  Future<List<Map<String, dynamic>>> getWorkouts() async {
    final db = await database;
    return await db.query('workouts');
  }

  Future<int> addWorkout(Map<String, dynamic> workout) async {
    final db = await database;
    return await db.insert('workouts', workout);
  }

  // ---------- 🍎 Calories ----------
  Future<List<Map<String, dynamic>>> getCalories() async {
    final db = await database;
    return await db.query('calories');
  }

  Future<int> addCalorie(Map<String, dynamic> calorie) async {
    final db = await database;
    return await db.insert('calories', calorie);
  }

  // ---------- 📅 Routines ----------
  Future<List<Map<String, dynamic>>> getRoutines() async {
    final db = await database;
    return await db.query('routines');
  }

  Future<int> addRoutine(Map<String, dynamic> routine) async {
    final db = await database;
    return await db.insert('routines', routine);
  }

  // ---------- ⚖️ Progress ----------
  Future<List<Map<String, dynamic>>> getProgress() async {
    final db = await database;
    return await db.query('progress');
  }

  Future<int> addProgress(Map<String, dynamic> progress) async {
    final db = await database;
    return await db.insert('progress', progress);
  }

  // ---------- 🧹 Generic Deleter ----------
  Future<int> deleteById(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // ---------- 🧼 Wipe DB (optional) ----------
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('workouts');
    await db.delete('calories');
    await db.delete('routines');
    await db.delete('progress');
  }
}
