import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:planet_pet/screens/pet_adoption_pending.dart';
import 'package:planet_pet/widgets/custom_scaffold.dart';
import '../models/animal.dart';

class PetDetailPage extends StatefulWidget {
  final dynamic petDoc;
  final dynamic docId;
  final String userId;
  final DocumentSnapshot userDoc;
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;

  PetDetailPage(
      {Key key,
      this.petDoc,
      this.userId,
      this.docId,
      this.userDoc,
      this.darkMode,
      this.toggleTheme,
      this.signOut})
      : super(key: key);

  @override
  _PetDetailPageState createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final CollectionReference postsRef = Firestore.instance.collection('pets');
  final CollectionReference usersRef = Firestore.instance.collection('users');
  bool favorited;
  DocumentSnapshot docStatus;
  String petDocStatus;

  /*update the user to favorite the pet
  will now show up in user's favorites page */
  void favoritePet() async {
    getFavoriteStatus();
    print(favorited);
    if (favorited == false) {
      await usersRef.document(widget.userId).updateData({
        'favorites': FieldValue.arrayUnion([widget.docId])
      });
      getFavoriteStatus();
    } else {
      await usersRef.document(widget.userId).updateData({
        'favorites': FieldValue.arrayRemove([widget.docId])
      });
      getFavoriteStatus();
    }
  }

  void getFavoriteStatus() async {
    DocumentSnapshot userDoc = await usersRef.document(widget.userId).get();
    List<dynamic> favorites = userDoc['favorites'];
    if (favorites == null) {
      favorites = [];
      setState(() {
        favorited = false;
      });
    }
    if (favorites.contains(widget.docId)) {
      setState(() {
        favorited = true;
      });
    } else {
      setState(() {
        favorited = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.docId);
    getFavoriteStatus();
    if (favorited == null) {
      favorited = false;
    }
    getAvailability();
    if (petDocStatus == null) {
      petDocStatus = '';
    }
  }

  void getAvailability() async {
    docStatus = await postsRef.document(widget.docId).get();
    petDocStatus = docStatus['availability'];
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomScaffold(
      detailsPage: true,
      signOut: widget.signOut,
      user: widget.userDoc,
      scaffoldKey: _scaffoldKey,
      darkMode: widget.darkMode,
      toggleTheme: widget.toggleTheme,
      title: "${widget.petDoc['name']}'s Details",
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(orientation == Orientation.portrait
                    ? height * 0.035
                    : width * 0.035),
                child: Semantics(
                    child: AspectRatio(
                      //aspectRatio: 4/3,
                      aspectRatio:
                          orientation == Orientation.portrait ? 4 / 3 : 9 / 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            orientation == Orientation.portrait
                                ? height * 0.025
                                : width * 0.03),
                        child: Image.network(widget.petDoc['imageURL'],
                            fit: BoxFit.cover),
                      ),
                    ),
                    image: true,
                    label: "Image of ${widget.petDoc['name']}",
                    hint: "Image of ${widget.petDoc['name']}"),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.0075
                        : width * 0.0075),
              ),
              Text("Name: ${widget.petDoc['name']}"),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              Text(
                  "Distance: ${double.parse((SphericalUtil.computeDistanceBetween(LatLng(widget.petDoc['latitude'], widget.petDoc['longitude']), LatLng(widget.userDoc['latitude'], widget.userDoc['longitude'])) / 1000 * .621371).toStringAsFixed(1))} miles"),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              Text(
                  "Birthdate: ${DateFormat.yMMMMEEEEd().format(widget.petDoc['dateOfBirth'].toDate())}"),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              Text(
                  "Age: ${Animal(dateOfBirth: widget.petDoc['dateOfBirth'].toDate().toString()).getAge()}"),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              Text("Sex: ${widget.petDoc['sex']}"),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              Text("Animal type: ${widget.petDoc['animalType']}"),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              Text("Breed: ${widget.petDoc['breed']}"),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              widget.petDoc['goodAnimals']
                  ? Text('${widget.petDoc['name']} is good with other animals.')
                  : Text(
                      '${widget.petDoc['name']} is not good with other animals.'),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              widget.petDoc['goodChildren']
                  ? Text('${widget.petDoc['name']} is good with children.')
                  : Text('${widget.petDoc['name']} is not good with children.'),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              widget.petDoc['leashNeeded']
                  ? Text('Leash required')
                  : Text('Leash not required'),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text('Availability: ${widget.petDoc['availability']}'),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              Text('Status: ${widget.petDoc['status']}'),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              Text(
                'Description: ${widget.petDoc['description']}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.015
                        : width * 0.015),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: favorited
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border),
                    iconSize: orientation == Orientation.portrait ? height * 0.05 : width * 0.05,
                    color: Colors.red,
                    onPressed: favoritePet,
                  ),
                  Semantics(
                      child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          elevation: 11,
                          label: Text(
                            'Adopt',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green[300],
                          icon: Icon(Icons.pets, color: Colors.white),
                          onPressed: () async {
                            docStatus =
                                await postsRef.document(widget.docId).get();
                            petDocStatus = docStatus['availability'];
                            setState(() {});

                            if (petDocStatus == 'Available') {
                              // change status of pet to adoption pending
                              await postsRef.document(widget.docId).updateData({
                                'availability': 'Adoption Pending',
                              });

                              //navigate to Adoption Pending page
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PetAdoptionPending(
                                      darkMode: widget.darkMode,
                                      userDoc: widget.userDoc,
                                      toggleTheme: widget.toggleTheme,
                                      signOut: widget.signOut,
                                      petDoc: widget.petDoc),
                                ),
                              );
                            } else if (petDocStatus == 'Adoption Pending' ||
                                petDocStatus == 'Adopted') {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${widget.petDoc['name']} is pending adoption!'),
                                ),
                              );
                            }
                          }),
                      button: true,
                      label: "Adopt this pet",
                      hint: "Press this button to adopt this pet"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
