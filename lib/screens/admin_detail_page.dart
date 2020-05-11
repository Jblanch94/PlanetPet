import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:planet_pet/widgets/custom_scaffold.dart';

class AdminDetailPage extends StatefulWidget {
  final DocumentSnapshot document;
  final bool darkMode;
  final Function(bool) toggleTheme;

  const AdminDetailPage(
      {Key key, this.document, this.darkMode, this.toggleTheme})
      : super(key: key);

  @override
  _AdminDetailPageState createState() => _AdminDetailPageState();
}

class _AdminDetailPageState extends State<AdminDetailPage> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        scaffoldKey: _scaffoldKey,
        darkMode: widget.darkMode,
        toggleTheme: widget.toggleTheme,
        title: "${widget.document['name']}'s Details",
        body: ListView(
          children: <Widget>[
            Semantics(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image(
                  image: NetworkImage(widget.document['imageURL']),
                  height: 300,
                  width: 300,
                )
              ),
              label: "${widget.document['name']}'s Image",
              image: true,
            ),
            Text("Name: ${widget.document['name']}"),
            Text(
                "Birthdate: ${DateFormat.yMMMMEEEEd().format(widget.document['dateOfBirth'].toDate())}"),
            Text("Sex: ${widget.document['sex']}"),
            Text("Animal type: ${widget.document['animalType']}"),
            Text("Breed: ${widget.document['breed']}"),
            Text("Good with other animals: ${widget.document['goodAnimals']}"),
            Text("Good with children: ${widget.document['goodChildren']}"),
            Text("Leash needed: ${widget.document['leashNeeded']}"),
            Text("Availability: ${widget.document['availability']}"),
            Text("Status: ${widget.document['status']}"),
            Text("Description: ${widget.document['description']}"),
            Text("Latitude: ${widget.document['latitude']}"),
            Text("Longitude: ${widget.document['longitude']}"),
          ],
        ));
  }
}
