import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SyncService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'mesmer_sync.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pending_uploads(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            collection TEXT,
            data TEXT,
            timestamp INTEGER
          )
        ''');
      },
    );
  }

  Future<void> queueUpload(String collection, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('pending_uploads', {
      'collection': collection,
      'data': data.toString(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> syncNow() async {
    final db = await database;
    final List<Map<String, dynamic>> pending = await db.query('pending_uploads');
    for (var item in pending) {
      try {
        // Placeholder: actual upload to Firestore would go here
        await db.delete('pending_uploads', where: 'id = ?', whereArgs: [item['id']]);
      } catch (e) {}
    }
  }

  Future<int> pendingCount() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('pending_uploads');
    return result.length;
  }
}
