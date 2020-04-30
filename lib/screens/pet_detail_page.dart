import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planet_pet/models/user.dart';

class PetDetailPage extends StatefulWidget {
  final dynamic petDoc;
  final String userId;

  PetDetailPage({Key key, this.petDoc, this.userId}) : super(key: key);

  @override
  _PetDetailPageState createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  final CollectionReference postsRef = Firestore.instance.collection('pets');
  final CollectionReference usersRef = Firestore.instance.collection('users');
  String docId;
  bool favorited;

  /*update the user to favorite the pet 
  will now show up in user's favorites page */
  void favoritePet() async {
    getFavoriteStatus();
    setState(() {});
    print(favorited);
    if (favorited == false) {
      usersRef.document(widget.userId).updateData({
        'favorites': FieldValue.arrayUnion([docId])
      });
      getFavoriteStatus();
      setState(() {});
      print(favorited);
    } else {
      usersRef.document(widget.userId).updateData({
        'favorites': FieldValue.arrayRemove([docId])
      });
      getFavoriteStatus();
      setState(() {});
    }
  }

  void getDocId() {
    setState(() {
      docId = postsRef.document().documentID;
    });
  }

  void getFavoriteStatus() async {
    final favoriteList = await usersRef.document(widget.userId).get();
    bool favorited;
    favoriteList['favorites'].forEach((favorite) {
      if (favorite == docId) {
        favorited = true;
      } else if (favorite != docId) {
        favorited = false;
      } else {
        favorited = false;
      }
    });
    if (favorited == null) {
      favorited = false;
    }
    this.favorited = favorited;
  }

  @override
  void initState() {
    super.initState();
    getFavoriteStatus();
    setState(() {});
    getDocId();
    print(docId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Details'),
        centerTitle: true,
        titleSpacing: 0,
      ),
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
              Text("Birthdate: ${widget.petDoc['dateOfBirth']}"),
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
                    icon: Icon(Icons.check_circle, color: Colors.white),
                    onPressed: () => print('Adopted'),
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
