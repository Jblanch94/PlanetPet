import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planet_pet/widgets/custom_scaffold.dart';

class PetDetailPage extends StatefulWidget {
  final dynamic petDoc;
  final dynamic docId;
  final String userId;
  final bool darkMode;
  final Function(bool) toggleTheme;

  PetDetailPage(
      {Key key,
      this.petDoc,
      this.userId,
      this.docId,
      this.darkMode,
      this.toggleTheme})
      : super(key: key);

  @override
  _PetDetailPageState createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final CollectionReference postsRef = Firestore.instance.collection('pets');
  final CollectionReference usersRef = Firestore.instance.collection('users');
  bool favorited;

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
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
                padding: EdgeInsets.only(top: 32),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.petDoc['imageURL']),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text("Name: ${widget.petDoc['name']}"),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
//              Text("Birthdate: ${widget.petDoc['dateOfBirth']}"),
              Text(
                  "Birthdate: ${DateFormat.yMMMMEEEEd().format(widget.petDoc['dateOfBirth'].toDate())}"),

              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text("Sex: ${widget.petDoc['sex']}"),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text("Animal type: ${widget.petDoc['animalType']}"),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text("Breed: ${widget.petDoc['breed']}"),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              widget.petDoc['goodAnimals']
                  ? Text('${widget.petDoc['name']} is good with other animals.')
                  : Text(
                      '${widget.petDoc['name']} is not good with other animals.'),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              widget.petDoc['goodChildren']
                  ? Text('${widget.petDoc['name']} is good with children.')
                  : Text('${widget.petDoc['name']} is not good with children.'),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              widget.petDoc['leashNeeded']
                  ? Text('Leash required')
                  : Text('Leash not required'),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text('Availability: ${widget.petDoc['availability']}'),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text('Status: ${widget.petDoc['status']}'),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text(
                'Description: ${widget.petDoc['description']}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: favorited
                        ? Icon(Icons.star, color: Colors.yellow)
                        : Icon(Icons.star_border),
                    iconSize: 30,
                    color: Colors.yellow[700],
                    onPressed: favoritePet,
                  ),
                  RaisedButton.icon(
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
                    onPressed: () => _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                          content:
                              Text('Adoption pending, we will be in touch!')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
