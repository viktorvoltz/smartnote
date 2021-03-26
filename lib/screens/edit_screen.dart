import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:smartnote/inherited_widget/note_inherited_widget.dart';
import 'package:smartnote/providers/note_provider.dart';
import 'package:smartnote/screens/note_llist.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:image/image.dart' as imageprocess;
import 'dart:convert';

class EditScreen extends StatefulWidget {
  String id;
  //final int index;
  final Map<String, dynamic> note;

  EditScreen({this.id, this.note});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> get _notes =>
      NoteInheritedWidget.of(context).lie();
  List<Map<String, dynamic>> get _rnotes =>
      NoteInheritedWidget.of(context).notes;

  File _storedImage;
  File ssavedImage;
  String base64Image;
  String time;

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _stext = 'speech text';

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
    final dimageFile = imageprocess.decodeImage(_storedImage.readAsBytesSync());
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    ssavedImage = savedImage;
    base64Image = base64.encode(imageprocess.encodePng(dimageFile));
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void didChangeDependencies() {
    _titleController.text =  widget.note['title'];
    _textController.text =  widget.note['text'];
    time = widget.note['time'];
    _stext = widget.note['_stext'].toString().split(" ").join();
    base64Image = widget.note['photo'];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
   

  
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        cursorColor: Colors.purple,
                        cursorWidth: 2.0,
                        decoration: InputDecoration(
                            hintText: 'Title', border: InputBorder.none),
                        maxLines: 2,
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: Colors.purple,
                        //cursorRadius: Radius.circular(16.0),
                        cursorWidth: 2.0,
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
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              child: Image.memory(base64.decode(widget.note['photo']), fit: BoxFit.cover,),
                            ),
                    ],
                  ))),
        ],
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
                    //String time = DateFormat('MM-dd,EEE  kk:mm:ss')
                        //.format(DateTime.now())
                        //.toString();
                    final title = _titleController.text;
                    final text = _textController.text;
                    /*String time = DateFormat('MM-dd,EEE  kk:mm:ss')
                          .format(DateTime.now())
                          .toString();*/
                    /*for (var i = 0; i <= _rnotes.length - 1; i++) {
                      if (_rnotes[i]['time'] == widget.id) {
                        _rnotes[i] = {
                          'title': title,
                          'text': text,
                          'time': time,
                          'photo': ssavedImage,
                          'stext': _stext
                        };
                      }
                    }*/
                    NoteProvider.updateNote({
                      'id': widget.note['id'],
                      'title': _titleController.text,
                      'text': _textController.text,
                      'time': time,
                      'photo': base64Image,
                      'stext': _stext,
                    });
                    final testtt = NoteList();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => testtt));
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
                  child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await NoteProvider.deleteNote(widget.note['id']);
                  final tryyy = NoteList();
                  //_notes.removeAt(widget.index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => tryyy,
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
