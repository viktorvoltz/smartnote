import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



class NoteProvider {
  static Database db;

  static Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'notes.db'),
        version: 1, onCreate: (Database db, int version) async {
      db.execute(''' 
        CREATE TABLE Notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          text TEXT,
          time TEXT,
          photo TEXT,
          stext TEXT
        );
      ''');
    });
    
  }

  static Future<List<Map<String, dynamic>>> getNoteList() async {
    if (db == null || !db.isOpen) {
      await open();
      
    }
    return await db.query('Notes');
  }

  static Future insertNote(table, note) async {
    await db.insert(
      table,
      note,
      conflictAlgorithm: ConflictAlgorithm.replace);
  
  }

  static Future updateNote(Map<String, dynamic> note) async {
    await db.update(
      'Notes',
      note,
      where: 'id = ?',
      whereArgs: [note['id']]
    );
  }

  static Future deleteNote(int id) async {
    await db.delete(
      'Notes',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

}


