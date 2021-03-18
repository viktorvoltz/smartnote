import 'package:flutter/material.dart';

class NoteInheritedWidget extends InheritedWidget{

  final List<Map<String, dynamic>> notes = [
    

  ];

  NoteInheritedWidget(Widget child) : super(child: child);

  static NoteInheritedWidget of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(NoteInheritedWidget) as NoteInheritedWidget);

  }

  @override
  bool updateShouldNotify(NoteInheritedWidget oldWidget) {
    return oldWidget.notes != notes;
  }
}