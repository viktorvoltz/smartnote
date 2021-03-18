import 'package:flutter/material.dart';
import 'package:smartnote/inherited_widget/note_inherited_widget.dart';
import 'package:smartnote/screens/note_llist.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:image_picker/image_picker.dart';

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
  List<Map<String, dynamic>> get _notes =>
      NoteInheritedWidget.of(context).notes;

  File _storedImage;
  File ssavedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    ssavedImage = savedImage;
  }

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
              SizedBox(height: 5),
              _storedImage == null
                  ? FlatButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label: Text(
                        'Take Picture',
                      ),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _takePicture,
                    )
                  : Container(
                      //width: size.width * 0.5,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: Image.file(_storedImage,
                              fit: BoxFit.cover, width: double.infinity),
                    ),
              Container(
                  width: widget.noteMode == NoteMode.Editing ? 400 : 200,
                  margin: EdgeInsets.only(top: 50),
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
                                String time = DateFormat('MM-dd,EEE  kk:mm:ss')
                                    .format(DateTime.now())
                                    .toString();


                                _notes.add({
                                  'title': title,
                                  'text': text,
                                  'time': time,
                                  'photo': ssavedImage
                                });
                                print(_notes);
                              } else if (widget?.noteMode == NoteMode.Editing) {
                                final title = _titleController.text;
                                final text = _textController.text;

                                _notes[widget.index] = {
                                  'title': title,
                                  'text': text
                                };
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NoteList()));
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NoteList(),
                                      ),
                                    );
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
