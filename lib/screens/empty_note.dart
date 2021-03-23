import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'note.dart';

class EmptyNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              //margin: EdgeInsets.only(left: 200),
              height: 300,
              //color: Colors.grey,
              width: 300,
              child: SvgPicture.asset(
                'assets/svg/illustration.svg',
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              child: Text(
                'looks like your note is empty, \n let\'s make one now ;)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: 250,
              child: FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Note(
                        noteMode: NoteMode.Adding,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Get Started :)',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xffFBC103),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
          ]),
    ));
  }
}
