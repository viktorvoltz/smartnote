import 'package:flutter/material.dart';
import 'note_llist.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    double size = MediaQuery.of(context).size.height; 
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Notes', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0
      ),

      body: Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(bottom: 60),
        child: RaisedButton(
          child: Text('Get started'),
          onPressed: (){
            Navigator.of(context).pushNamed(NoteList.routeName);
          },
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}