import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/models/history_item.dart';

class LocalStorageService {
  static const String _tableName = 'history';

  /// 최근 기록 최대 보관 개수 (초과 시 오래된 것부터 삭제)
  static const int _maxHistoryCount = 15;

  Database? _db;

  Future<void> init() async {
    if (_db != null) return;
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
    // 같은 주소(=같은 계약서)의 기존 기록이 있으면 중복으로 간주.
    // 실제 분석은 같은 계약서여도 AI가 조항을 매번 미세하게 다르게 주므로,
    // 조항 비교 대신 주소로 판단한다.
    // 중복이면 최신 결과로 덮어쓰고 시각을 갱신해 목록 맨 위로 올린다.
    final existing = await getHistory();
    final duplicate = _findBySameAddress(existing, item.address);

    if (duplicate?.id != null) {
      await _db!.update(
        _tableName,
        item.toMap()..remove('id'),
        where: 'id = ?',
        whereArgs: [duplicate!.id],
      );
    } else {
      await _db!.insert(_tableName, item.toMap());
    }

    await _trimToLimit();
  }

  /// 주소가 같은(비어 있지 않은) 기존 기록을 찾는다. 같은 계약서로 간주.
  /// 주소가 비어 있으면 비교 불가하므로 항상 새 기록으로 추가한다.
  HistoryItem? _findBySameAddress(List<HistoryItem> list, String address) {
    final target = address.trim();
    if (target.isEmpty) return null;
    for (final item in list) {
      if (item.address.trim() == target) return item;
    }
    return null;
  }

  /// 보관 개수를 초과하면 오래된 기록부터 삭제한다.
  Future<void> _trimToLimit() async {
    final rows = await _db!.query(
      _tableName,
      columns: ['id'],
      orderBy: 'created_at DESC',
    );
    if (rows.length <= _maxHistoryCount) return;

    final idsToDelete =
        rows.skip(_maxHistoryCount).map((e) => e['id'] as int).toList();
    final placeholders = List.filled(idsToDelete.length, '?').join(',');
    await _db!.delete(
      _tableName,
      where: 'id IN ($placeholders)',
      whereArgs: idsToDelete,
    );
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
