import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:smartnote/inherited_widget/note_inherited_widget.dart';
import 'package:smartnote/screens/note_llist.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

enum NoteMode { Editing, Adding }

class Note extends StatefulWidget {
  final NoteMode noteMode;
  final int index;
  String id;

  Note({this.noteMode, this.index, this.id});

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
      NoteInheritedWidget.of(context).lie();
  List<Map<String, dynamic>> get _rnotes =>
      NoteInheritedWidget.of(context).notes;

  File _storedImage;
  File ssavedImage;

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _stext = 'speech text';
  double _confidence = 1.0;

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
        debugLogging: true,
      );
      if (available) {
        setState(() => _isListening = true);
        await _speech.listen(
            onResult: (val) => setState(() {
                  _stext = val.recognizedWords;
                  if (val.hasConfidenceRating && val.confidence > 0) {
                    _confidence = val.confidence;
                  }
                }));
      }
    } else {
      setState(() => _isListening = false);
      await _speech.stop();
    }
  }

  final Map<String, HighlightedWord> _highlights = {
    'chinonso': HighlightedWord(
      onTap: () => print('chinonso'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

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
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.noteMode == NoteMode.Adding ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                cursorColor: Colors.purple,
                cursorWidth: 10.0,
                decoration: InputDecoration(
                    hintText: 'Tittle', border: InputBorder.none),
                maxLines: 2,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: Colors.purple,
                //cursorRadius: Radius.circular(16.0),
                cursorWidth: 10.0,
                //maxLength: 50,
                controller: _textController,
                decoration: InputDecoration(
                    hintText: 'Write here', border: InputBorder.none),
              ),
              SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 20, bottom: 50),
                  child: TextHighlight(
                    text: _stext,
                    textAlign: TextAlign.left,
                    words: _highlights,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              _storedImage == null
                  ? Container(child: Text('image will display here'))
                  : Container(
                      //width: size.width * 0.5,
                      height: 300,
                      width: screenWidth - 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: Image.file(_storedImage,
                          fit: BoxFit.fill,),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.purple,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  onPressed: _takePicture,
                ),
              ),
              //Spacer(),
              Container(
                child: IconButton(
                  //color: Colors.blue,
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  //child: Text('save',style: TextStyle(color: Colors.white, fontSize: 18)),
                  onPressed: () {
                    String time = DateFormat('MM-dd,EEE  kk:mm:ss')
                        .format(DateTime.now())
                        .toString();
                    if (widget?.noteMode == NoteMode.Adding) {
                      final title = _titleController.text;
                      final text = _textController.text;
                      /*String time = DateFormat('MM-dd,EEE  kk:mm:ss')
                          .format(DateTime.now())
                          .toString();*/
                      _rnotes.add({
                        'title': title,
                        'text': text,
                        'time': time,
                        'photo': ssavedImage,
                        'stext': _stext,
                      });
                      print(_notes);
                    } else if (widget?.noteMode == NoteMode.Editing) {
                      final title = _titleController.text;
                      final text = _textController.text;
                      /*String time = DateFormat('MM-dd,EEE  kk:mm:ss')
                          .format(DateTime.now())
                          .toString();*/

                      for (var i = 0; i <= _rnotes.length - 1; i++) {
                        if (_rnotes[i]['time'] == widget.id) {
                          _rnotes[i] = {
                            'title': title,
                            'text': text,
                            'time': time,
                            'photo': ssavedImage,
                            'stext': _stext
                          };
                        }
                      }
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NoteList()));
                  },
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                child: widget.noteMode == NoteMode.Editing
                    ? IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          for (var i = 0; i <= _rnotes.length - 1; i++) {
                            if (_rnotes[i]['time'] == widget.id) {
                              _rnotes.removeAt(i);
                            }
                          }
                          //_notes.removeAt(widget.index);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteList(),
                            ),
                          );
                        },
                      )
                    : Container(),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: widget.noteMode == NoteMode.Editing
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.endDocked,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Colors.yellowAccent,
        endRadius: 30.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}
