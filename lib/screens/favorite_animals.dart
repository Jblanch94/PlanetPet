import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planet_pet/models/user.dart';

class FavoriteAnimals extends StatefulWidget {
  final String userId;

  FavoriteAnimals({this.userId});

  @override
  _FavoriteAnimalsState createState() => _FavoriteAnimalsState();
}

class _FavoriteAnimalsState extends State<FavoriteAnimals> {
  CollectionReference usersRef = Firestore.instance.collection('users');
  CollectionReference postsRef = Firestore.instance.collection('pets');
  dynamic userFavorites;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserFavorites();
  }

  void fetchCurrentUserFavorites() async {
    DocumentSnapshot userDoc = await usersRef.document(widget.userId).get();
    final docs = userDoc.data['favorites'];
    userFavorites = docs;
    setState(() {
      userFavorites = docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: postsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (_, index) {
                  var record = snapshot.data.documents[index];
                  String recordId = record.documentID;

                  print(userFavorites.contains(recordId));

                  //TODO: Add pet details for favorited
                  if (userFavorites.contains(recordId)) {
                    return Text('valid');
                  } else return Container();
                });
          }
        });
  }
}
