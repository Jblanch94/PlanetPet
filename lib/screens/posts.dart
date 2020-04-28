import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Posts extends StatelessWidget {
  final CollectionReference postsRef = Firestore.instance.collection('pets');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
          body: StreamBuilder(
          stream: postsRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (_, index) {
                  return Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          snapshot.data.documents[index]['imageURL']
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8
                        ),
                      ),
                      Text(
                        snapshot.data.documents[index]['name']
                      ),
                    ],
                  );
                }
              ),
            );
          }),
    );
  }
}
