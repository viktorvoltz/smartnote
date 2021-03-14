import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  static const routeName = 'NoteList';
  @override
  Widget build(BuildContext context) {
    
    return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10),
            itemCount: 10,
            itemBuilder: (BuildContext ctx, index) {
              return Card(
                child: Text('#${index + 1}'),
              );
            });
  }
}