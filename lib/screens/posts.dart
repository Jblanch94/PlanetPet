import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planet_pet/screens/pet_detail_page.dart';

class Posts extends StatelessWidget {
  final CollectionReference postsRef = Firestore.instance.collection('pets');

  void viewPetDetails(BuildContext context, dynamic petDoc) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PetDetailPage(petDoc: petDoc)
    ));
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
                    return Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => viewPetDetails(context, petDoc),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                petDoc['imageURL']),
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
