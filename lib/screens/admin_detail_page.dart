import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDetailPage extends StatelessWidget {

  final DocumentSnapshot document;

  AdminDetailPage(this.document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Planet Pet')),
      body: ListView(
      children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image(
              image: NetworkImage(document['imageURL']),
              height: 300,
              width: 300,
            )
          ),
          Text("Name: ${document['name']}"),
          Text("Birthdate: ${document['dateOfBirth']}"),
          Text("Sex: ${document['sex']}"),
          Text("Animal type: ${document['animalType']}"),
          Text("Breed: ${document['breed']}"),
          Text("Good with other animals: ${document['goodAnimals']}"),
          Text("Good with children: ${document['goodChildren']}"),
          Text("Leash needed: ${document['leashNeeded']}"),
          Text("Availability: ${document['availability']}"),
          Text("Status: ${document['status']}"),
          Text("Description: ${document['description']}"),
          Text("Latitude: ${document['latitude']}"),
          Text("Longitude: ${document['longitude']}"),
        ],
      )
    );
  }
}