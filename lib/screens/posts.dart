import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planet_pet/screens/pet_detail_page.dart';

class Posts extends StatelessWidget {

  final String userId;

  Posts({this.userId});
  final CollectionReference postsRef = Firestore.instance.collection('pets');

  void viewPetDetails(BuildContext context, dynamic petDoc, dynamic docId) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PetDetailPage(petDoc: petDoc, userId: userId, docId: docId)));
  }

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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    var petDoc = snapshot.data.documents[index];
                    var docId = snapshot.data.documents[index].documentID;
                    return Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => viewPetDetails(context, petDoc, docId),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: CachedNetworkImageProvider(
                              petDoc['imageURL'],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                        ),
                        Text(snapshot.data.documents[index]['name']),
                      ],
                    );
                  }),
            );
          }),
    );
  }
}
