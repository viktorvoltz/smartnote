import 'package:flutter/material.dart';
import 'package:smartnote/screens/note_llist.dart';
import 'screens/homescreen.dart';

void main(){
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Note',
      home: HomeScreen(),
      routes: {
        NoteList.routeName: (ctx) => NoteList(),
      }
    );
  }
}