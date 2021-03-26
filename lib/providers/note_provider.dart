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
    print('open fuckkkkkkkkkkkkkk');
  }

  static Future<List<Map<String, dynamic>>> getNoteList() async {
    if (db == null || !db.isOpen) {
      await open();
      print('is openninnggg');
    }
    return await db.query('Notes');
  }

  /*static Future<List<Map<String, dynamic>>> dogs(notes) async {
    // Get a reference to the database.
    final Database db = await open();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return notes(
        title: maps[i]['title'],
        text: maps[i]['text'],
        time: maps[i]['time'],
        ssavedImage: maps[i]['photo'],
        stext: maps[i]['stext']
      );
    }).reversed.toList();
  }*/

  static Future insertNote(table, note) async {
    await db.insert(
      table,
      note,
      conflictAlgorithm: ConflictAlgorithm.replace);
    print('insert has been called');
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


