import 'package:flutter/material.dart';

enum NoteMode{
  Editing,
  Adding
}

class Note extends StatelessWidget {
  final NoteMode _noteMode;

  Note(this._noteMode);

  static const routeName = 'Note';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _noteMode == NoteMode.Adding ? 'Add Note' : 'Edit Note'
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextField(decoration: InputDecoration(hintText: 'Tittle'), maxLines: 2, ),
              TextField(decoration: InputDecoration(hintText: 'Write here'),),
               Container(
                 width: _noteMode == NoteMode.Editing ? 400 : 200,
                 margin: EdgeInsets.only(top: 300),
                  child: Card(
                    
                    color: Colors.purple,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      FlatButton(
                        color: Colors.blue,
                        child: Text('save', style: TextStyle(color: Colors.white, fontSize: 18)),
                        onPressed: () {},
                      ),
                      //Spacer(),
                      FlatButton(
                        child: Text('discard', style: TextStyle(fontSize: 18),),
                        onPressed: () {},
                      ),
                      _noteMode == NoteMode.Editing ? 
                      FlatButton(
                        child: Text('Delete', style: TextStyle(fontSize: 18),),
                        onPressed: () {},
                      ) : Container(),
                    ]),
                  ))
            ],
            
          ),
        ));
  }
}
