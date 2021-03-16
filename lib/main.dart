import 'package:flutter/material.dart';
import 'inherited_widget/note_inherited_widget.dart';
import 'package:smartnote/screens/note_llist.dart';
import 'screens/homescreen.dart';
import 'screens/note.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoteInheritedWidget(
        MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Note',
        home: HomeScreen(),
        routes: {
          NoteList.routeName: (ctx) => NoteList(),
          Note.routeName: (ctx) => Note(noteMode: NoteMode.Adding),
        }
      ),
    );
  }
}