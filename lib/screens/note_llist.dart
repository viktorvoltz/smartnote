import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smartnote/inherited_widget/note_inherited_widget.dart';
import 'package:smartnote/providers/note_provider.dart';
import 'package:smartnote/screens/views.dart';
import 'note.dart';
import 'views.dart';

class NoteList extends StatefulWidget {
  static const routeName = 'NoteList';
  //String image;

  //NoteList({this.image});

  @override
  NoteListState createState() {
    return new NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  //List<Map<String, dynamic>> get notes =>
  //NoteInheritedWidget.of(context).lie();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272637),
      body: FutureBuilder(
        future: NoteProvider.getNoteList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //final _byteImage = Base64Decoder().convert(widget.image);
            final List notes = snapshot.data;
            List notess = notes.reversed.toList();
            print(notes);
            return GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10),
              itemCount: notess.length,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Views(
                                  index: index,
                                  time: notess[index]['time'],
                                  note: notess[index],
                                )));
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
                                    notess[index]['photo'] == null
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(bottom: 2),
                                            height: 70,
                                            width: double.infinity,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.memory(base64.decode(notess[index]['photo']), fit: BoxFit.none,),
                                            ),
                                          ),
                                    _NoteTittle(
                                      notess[index]['title'],
                                    ),
                                    SizedBox(height: 4),
                                    _NoteText(notess[index]['text']),
                                    notess[index]['stext'] == 'speech text' || notess[index]['stext'] == 'null'
                                        ? Container()
                                        : Container(
                                            child: Text(
                                              notess[index]['stext'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1,
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
                              notess[index]['time'],
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
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
