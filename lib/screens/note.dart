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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image/image.dart' as imageprocess;
import 'dart:convert';

enum NoteMode { Editing, Adding }

class Note extends StatefulWidget {
  final NoteMode noteMode;
  final Map<String, dynamic> note;
  String id;

  Note({this.noteMode, this.note, this.id});

  static const routeName = 'Note';

  @override
  NoteState createState() {
    return new NoteState();
  }
}

class NoteState extends State<Note> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  //List<Map<String, dynamic>> get _notes =>
      //NoteInheritedWidget.of(context).lie();
 // List<Map<String, dynamic>> get _rnotes =>
      //NoteInheritedWidget.of(context).notes;

  File _storedImage;
  File photo;
  String base64Image;

  stt.SpeechToText _speech;
  bool _isListening = false;
  String stext = 'speech text';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
                  stext = val.recognizedWords;
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
    photo = savedImage;
    base64Image = base64.encode(imageprocess.encodePng(dimageFile));
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    /*FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidInitialize = new AndroidInitializationSettings('app_icon');
    var iosInitialize = new IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: notificationSelected);*/
  }
  

  /*Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
      "channelID",
      "note notification",
      "channelDescription",
      importance: Importance.High,
      priority: Priority.Max,
      icon: 'launch_icon',
      sound: RawResourceAndroidNotificationSound('a_long_cold_string'),
      largeIcon: DrawableResourceAndroidBitmap('launch_icon'),
    );
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iosDetails);

    /*return await flutterLocalNotificationsPlugin.show(
        1, "Task", "Task notification", generalNotificationDetails, payload: 'test notification');*/

    var scheduledTime = DateTime.now().add(Duration(seconds: 6));


    await flutterLocalNotificationsPlugin.schedule(
        0, "title", "body", scheduledTime, generalNotificationDetails);
  }*/

  @override
  Widget build(BuildContext context) {
    /*if (widget.noteMode == NoteMode.Editing) {
      _titleController.text = widget.note['title'];
      _textController.text = widget.note['text'];
    }*/
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        /*actions: [
          IconButton(
            onPressed: _showNotification,
            icon: Icon(Icons.notifications_active_sharp),
          )
        ],*/
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
                cursorColor: Colors.blue,
                cursorWidth: 2.0,
                decoration: InputDecoration(
                    hintText: 'Title', border: InputBorder.none),
                maxLines: 2,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: Colors.blue,
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
                    text: stext,
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
                  ? Container(child: Text('image will display here', style: Theme.of(context).textTheme.title,))
                  : Container(
                      //width: size.width * 0.5,
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: Image.file(
                       _storedImage,
                        fit: BoxFit.fill,
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color(0xff3B3A50),
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
                child: Builder(builder: (context) => 
                 IconButton(
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
                      int id;
                      Map<String, dynamic> note = ({
                        //'id': id,
                        'title': title,
                        'text': text,
                        'time': time,
                        'photo': base64Image,
                        'stext': stext,
                      });

                      if(_titleController.text.isEmpty && _textController.text.isEmpty && base64Image == null && stext == 'speech text'){
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('please make a note', style: Theme.of(context).textTheme.body1,),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }else{
                        NoteProvider.insertNote('Notes', note);
                        print('$base64Image');
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoteList()));
                      }

                      
                    } else if (widget?.noteMode == NoteMode.Editing) {
                      final title = _titleController.text;
                      final text = _textController.text;
                    }
                    
                  },
                ),
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
