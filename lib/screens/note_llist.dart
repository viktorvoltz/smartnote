import 'package:flutter/material.dart';
import 'package:smartnote/inherited_widget/note_inherited_widget.dart';
import 'package:smartnote/screens/views.dart';
import 'note.dart';
import 'views.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class NoteList extends StatefulWidget {
  static const routeName = 'NoteList';
  //File pickedImage;

  //NoteList({this.pickedImage});

  @override
  NoteListState createState() {
    return new NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  List<Map<String, dynamic>> get _notes =>
      NoteInheritedWidget.of(context).notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272637),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10),
        itemCount: _notes.length,
        itemBuilder: (BuildContext ctx, index) {
          return GestureDetector(
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Views(index: index)));
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _notes[index]['photo'] == null ?
                      Container() :
                      Container(
                        height: 50,
                        width: 50,
                        child: Image.file(_notes[index]['photo']),
                      ),
                      _NoteTittle(_notes[index]['title']),
                      SizedBox(height: 4),
                      _NoteText(_notes[index]['text']),
                      Spacer(),
                      Text(
                        _notes[index]['time'],
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  )),
              decoration: BoxDecoration(
                  color: Color(0xff3B3A50),
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        //shape:  CircularNotchedRectangle(),
        color: Colors.purple,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {},
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Note(noteMode: NoteMode.Adding)));
          setState(() {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _NoteText extends StatelessWidget {
  final String _text;

  _NoteText(this._text);
  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(color: Colors.white30, fontSize: 18),
      maxLines: 7,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
    );
  }
}

class _NoteTittle extends StatelessWidget {
  final String _tittle;

  _NoteTittle(this._tittle);
  @override
  Widget build(BuildContext context) {
    return Text(
      _tittle.toUpperCase(),
      style: TextStyle(color: Colors.white, fontSize: 30),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
