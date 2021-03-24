import 'package:flutter/material.dart';
import 'package:smartnote/inherited_widget/note_inherited_widget.dart';
import 'package:smartnote/screens/views.dart';
import 'note.dart';
import 'views.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class NoteList extends StatefulWidget {
  static const routeName = 'NoteList';
  //String time;

  //NoteList({this.time});

  @override
  NoteListState createState() {
    return new NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  List<Map<String, dynamic>> get _notes =>
      NoteInheritedWidget.of(context).lie();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272637),
      body: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10),
        itemCount: _notes.length,
        itemBuilder: (BuildContext ctx, index) {
          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Views(index: index, time: _notes[index]['time'])));
              setState(() {});
            },
            child: Container(
              height: 200,
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, bottom: 5, left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Container(
                              child: Column(
                                children: [
                                  _notes[index]['photo'] == null
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.only(bottom: 2),
                                          height: 70,
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.file(
                                              _notes[index]['photo'],
                                              fit: BoxFit.none,
                                            ),
                                          ),
                                        ),
                                  _NoteTittle(
                                    _notes[index]['title'],
                                  ),
                                  SizedBox(height: 4),
                                  _NoteText(_notes[index]['text']),
                                  _notes[index]['stext'] == 'speech text'
                                      ? Container()
                                      : Container(
                                          child: Text(
                                            _notes[index]['stext'],
                                            style:
                                                Theme.of(context).textTheme.body1,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            _notes[index]['time'],
                            style: Theme.of(context).textTheme.body2,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  
                ),
                decoration: BoxDecoration(
                    color: Color(0xff3B3A50),
                    borderRadius: BorderRadius.circular(10)),
              ),
            
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.purple,
        child: Container(
          height: 50,
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushReplacement(
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
      style: Theme.of(context).textTheme.body1,
      maxLines: 5,
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
      style: Theme.of(context).textTheme.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}

