import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:smartnote/inherited_widget/note_inherited_widget.dart';
import 'package:smartnote/providers/note_provider.dart';
import 'note_llist.dart';
import 'empty_note.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  //List<Map<String, dynamic>> get _notes => NoteInheritedWidget.of(context).notes;
  

  bool appState = true;
  int count;
  static Database db;

  
  void tableIsEmpty()async{
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

    //if (db == null || !db.isOpen){
    //  await NoteProvider.getNoteList();
    //}
    var x = await db.rawQuery('SELECT COUNT(*) FROM Notes');
    setState(() {
      count = Sqflite.firstIntValue(x);
    });
    print(count);
  }
  

  @override
  void initState(){
    tableIsEmpty();
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    print('checking $count');
    //double size = MediaQuery.of(context).size.height; 
    return count == 0 ? Scaffold(body: EmptyNote()) : NoteList(); 
  }
}