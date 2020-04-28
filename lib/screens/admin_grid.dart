import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planet_pet/screens/admin_detail_page.dart';

  Widget _buildGridItem(BuildContext context, DocumentSnapshot document) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image(
                image: NetworkImage(document['imageURL']),
                height: 150,
                width: 150,
              )
            ),
            Text(document['name'], style: TextStyle(fontSize: 14)),
            Text(document['availability'], style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminDetailPage(document) // AdminDetailPage(document: document)
          )
        );
      },
    );
  }

class AdminGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('pets').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
              _buildGridItem(context, snapshot.data.documents[index]),
          );
        }
      );
  }
}