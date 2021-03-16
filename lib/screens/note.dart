import 'package:flutter/material.dart';
import 'package:smartnote/inherited_widget/note_inherited_widget.dart';
import 'package:smartnote/screens/note_llist.dart';

enum NoteMode { Editing, Adding }

class Note extends StatefulWidget {
  final NoteMode noteMode;
  final int index;

  Note({this.noteMode, this.index});

  static const routeName = 'Note';

  @override
  NoteState createState() {
    return new NoteState();
  }
}

class NoteState extends State<Note> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;

  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.Editing) {
      _titleController.text = _notes[widget?.index]['title'];
      _textController.text = _notes[widget?.index]['text'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.noteMode == NoteMode.Adding ? 'Add Note' : 'Edit Note'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: 'Tittle'),
                maxLines: 2,
              ),
              TextField(
                controller: _textController,
                decoration: InputDecoration(hintText: 'Write here'),
              ),
              Container(
                  width: widget.noteMode == NoteMode.Editing ? 400 : 200,
                  margin: EdgeInsets.only(top: 300),
                  child: Card(
                    color: Colors.purple,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            color: Colors.blue,
                            child: Text('save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            onPressed: () {
                              if (widget?.noteMode == NoteMode.Adding) {
                                final title = _titleController.text;
                                final text = _textController.text;

                                _notes.add({'title': title, 'text': text});
                                print(_notes);
                              } else if (widget?.noteMode == NoteMode.Editing) {
                                final title = _titleController.text;
                                final text = _textController.text;

                                _notes[widget.index] = {
                                  'title': title,
                                  'text': text
                                };
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NoteList()));
                            },
                          ),
                          //Spacer(),
                          FlatButton(
                            child: Text(
                              'discard',
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          widget.noteMode == NoteMode.Editing
                              ? FlatButton(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    _notes.removeAt(widget.index);
                                    Navigator.pop(context);
                                  },
                                )
                              : Container(),
                        ]),
                  ))
            ],
          ),
        ));
  }
}
