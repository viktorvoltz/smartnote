import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smartnote/inherited_widget/note_inherited_widget.dart';
import 'note_llist.dart';
import 'edit_screen.dart';

class Views extends StatefulWidget {
  final int index;
  String time;
  final Map<String, dynamic> note;
  //final File image;
  Views({this.index, this.time, this.note});

  @override
  _ViewsState createState() => _ViewsState();
}

class _ViewsState extends State<Views> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272637),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.note['photo'] == null
                  ? Container()
                  : Container(
                      height: 300,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                          child: Image.memory(base64.decode(widget.note['photo']), fit: BoxFit.cover,)
                          ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                    ),
              SizedBox(height: 10),
              Container(
                child: Text(
                  widget.note['title'].toString().toUpperCase(),
                  style: TextStyle(fontFamily: 'Raleway', color: Colors.white, fontSize: 25),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Text(
                  widget.note['text'],
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    color: Colors.white38,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              widget.note['stext'] == 'speech text' || widget.note['stext'] == 'null' ? Container() :
              Container(
                child: Text(
                  widget.note['stext'],
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    color: Colors.white30,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 40),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  widget.note['time'],
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white30,
                    fontSize: 20,
                    fontWeight: FontWeight.w100
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.edit, color: Colors.white,),
        onPressed: () async {
           final first = EditScreen(note: widget.note, id:widget.time);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => first,
                  ),
                );
                //setState(() {});
        },
      ),
    );
  }
}
