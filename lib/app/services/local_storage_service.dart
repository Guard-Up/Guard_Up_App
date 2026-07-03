import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/models/history_item.dart';
import '../data/models/risk_analysis_response.dart';

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
    // 독소 조항(issues)이 완전히 같은 기존 기록이 있으면 중복으로 간주.
    // 새로 쌓지 않고, 기존 항목의 시각만 최신으로 갱신해 목록 맨 위로 올린다.
    final existing = await getHistory();
    final duplicate = _findBySameIssues(existing, item.issues);

    if (duplicate?.id != null) {
      await _db!.update(
        _tableName,
        {'created_at': item.createdAt.toIso8601String()},
        where: 'id = ?',
        whereArgs: [duplicate!.id],
      );
    } else {
      await _db!.insert(_tableName, item.toMap());
    }

    await _trimToLimit();
  }

  /// 독소 조항 목록이 완전히 동일한 기록을 찾는다. (순서 무관)
  HistoryItem? _findBySameIssues(List<HistoryItem> list, List<Issue> issues) {
    final target = _issueSignature(issues);
    for (final item in list) {
      if (_issueSignature(item.issues) == target) return item;
    }
    return null;
  }

  /// 조항 목록을 비교용 문자열로 변환 (내용 기준, 순서 영향 없도록 정렬).
  String _issueSignature(List<Issue> issues) {
    final keys = issues
        .map((i) => '${i.clause}|${i.reason}|${i.severity}|${i.isLegalBasis}')
        .toList()
      ..sort();
    return keys.join('##');
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
