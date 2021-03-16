import 'package:flutter/material.dart';
import 'package:smartnote/inherited_widget/note_inherited_widget.dart';
import 'note_llist.dart';
import 'empty_note.dart';

class HomeScreen extends StatefulWidget {

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;

  @override
  void didChangeDependencies() {
    
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height; 
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Notes', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0
      ),

      body: _notes.isEmpty ? EmptyNote() : NoteList()
    );
  }
}