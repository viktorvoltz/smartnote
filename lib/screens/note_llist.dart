import 'package:flutter/material.dart';
import 'note.dart';

class NoteList extends StatelessWidget {
  static const routeName = 'NoteList';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 5,
            mainAxisSpacing: 10),
        itemCount: 10,
        itemBuilder: (BuildContext ctx, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => Note(NoteMode.Editing)));
            },
            child: Card(
              child: Text('#${index + 1}'),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        //shape:  CircularNotchedRectangle(),
        color: Colors.purple,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Note(NoteMode.Adding)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
