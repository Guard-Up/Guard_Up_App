import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/models/history_item.dart';

class LocalStorageService {
  static const String _tableName = 'history';
  Database? _db;

  Future<void> init() async {
    final path = join(await getDatabasesPath(), 'guard_up.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            address TEXT NOT NULL,
            score INTEGER NOT NULL,
            level TEXT NOT NULL,
            issues TEXT NOT NULL,
            action_guide TEXT NOT NULL,
            public_data TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> saveHistory(HistoryItem item) async {
    await _db!.insert(_tableName, item.toMap());
  }

  Future<List<HistoryItem>> getHistory() async {
    final maps = await _db!.query(
      _tableName,
      orderBy: 'created_at DESC',
    );
    return maps.map((e) => HistoryItem.fromMap(e)).toList();
  }

  Future<HistoryItem?> getHistoryById(int id) async {
    final maps = await _db!.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return HistoryItem.fromMap(maps.first);
  }

  Future<void> deleteHistory(int id) async {
    await _db!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
