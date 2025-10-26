import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dbName = "card_organizer.db";
  static const _dbVersion = 1;

  static Database? _database;

  /// Singleton pattern to ensure only one DB instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDB() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  /// Create tables and seed initial data
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        suit TEXT NOT NULL,
        image TEXT,
        folder_id INTEGER,
        FOREIGN KEY (folder_id) REFERENCES folders (id)
      )
    ''');

    // Prepopulate default folders
    final suits = ['Hearts', 'Spades', 'Diamonds', 'Clubs'];
    for (var s in suits) {
      await db.insert('folders', {'name': s, 'created_at': DateTime.now().toIso8601String()});
    }
  }

  // ---------- Folder CRUD ----------
  Future<List<Map<String, dynamic>>> getFolders() async {
    final db = await database;
    return await db.query('folders');
  }

  Future<int> addFolder(Map<String, dynamic> folder) async {
    final db = await database;
    return await db.insert('folders', folder);
  }

  // ---------- Card CRUD ----------
  Future<List<Map<String, dynamic>>> getCardsByFolder(int folderId) async {
    final db = await database;
    return await db.query('cards', where: 'folder_id = ?', whereArgs: [folderId]);
  }

  Future<int> addCard(Map<String, dynamic> card) async {
    final db = await database;
    return await db.insert('cards', card);
  }

  Future<int> updateCard(Map<String, dynamic> card) async {
    final db = await database;
    return await db.update('cards', card, where: 'id = ?', whereArgs: [card['id']]);
  }

  Future<int> deleteCard(int id) async {
    final db = await database;
    return await db.delete('cards', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getCardCount(int folderId) async {
    final db = await database;
    final res = await db.rawQuery('SELECT COUNT(*) FROM cards WHERE folder_id = ?', [folderId]);
    return Sqflite.firstIntValue(res) ?? 0;
  }
}
