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
          builder: (context, child){
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: child,
            );
          },
        debugShowCheckedModeBanner: false,
        title: 'Smart Note',
        home: HomeScreen(),
        routes: {
          NoteList.routeName: (ctx) => NoteList(),
          
        }
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior{
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    
    return super.buildViewportChrome(context, child, axisDirection);
  }
}