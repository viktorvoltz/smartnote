import 'package:flutter/material.dart';
import 'package:smartnote/inherited_widget/note_inherited_widget.dart';
import 'note.dart';
import 'note_llist.dart';

class Views extends StatefulWidget {
  final int index;
  String time;
  //final File image;
  Views({this.index, this.time});

  @override
  _ViewsState createState() => _ViewsState();
}

class _ViewsState extends State<Views> {
  List<Map<dynamic, dynamic>> get _notes =>
      NoteInheritedWidget.of(context).lie();
  List<Map<String, dynamic>> get _rnotes => NoteInheritedWidget.of(context).notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272637),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(left: 5, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _notes[widget.index]['photo'] == null
                    ? Container()
                    : Container(
                        height: 200,
                        width: 200,
                        child: Image.file(_notes[widget.index]['photo']),
                      ),
                Container(
                  child: Text(
                    _notes[widget.index]['title'],
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: Text(
                    _notes[widget.index]['text'],
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  child: Text(
                    _notes[widget.index]['stext'],
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _notes[widget.index]['time'],
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        //shape:  CircularNotchedRectangle(),
        color: Colors.purple,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Note(noteMode: NoteMode.Editing, index: widget.index, id: widget.time),
                  ),
                );
                setState(() {});
              },
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                for (var i = 0; i <= _rnotes.length - 1; i++) {
                  if (_rnotes[i]['time'] == widget.time) {
                    _rnotes.removeAt(i);
                    
                  }
                }
               // _rnotes.removeWhere((element) => element[widget.index]['time'] == widget.time);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteList(),
                  ),
                );
                //setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
