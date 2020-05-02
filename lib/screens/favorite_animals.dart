import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    if (userFavorites == null) {
      userFavorites = [];
    }
  }

  void fetchCurrentUserFavorites() async {
    DocumentSnapshot userDoc = await usersRef.document(widget.userId).get();
    final docs = userDoc.data['favorites'];
    userFavorites = docs;
    setState(() {
      userFavorites = docs;
    });
  }

  Widget buildPostPet(dynamic record, String url) {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: FittedBox(
                    child: CachedNetworkImage(imageUrl: url),
                    fit: BoxFit.contain,
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Name'),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                              ),
                              Text('${record['name']}')
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Column(
                            children: <Widget>[
                              Text('Sex'),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                              ),
                              Text('${record['sex']}')
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Column(
                            children: <Widget>[
                              Text('Animal Type'),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                              ),
                              Text('${record['animalType']}')
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Column(
                            children: <Widget>[
                              Text('Breed'),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                              ),
                              Text('${record['breed']}')
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Column(
                            children: <Widget>[
                              Text('Good with other animals'),
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                              ),
                              Text(record['goodAnimals'] ? 'Yes' : 'No')
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Column(
                            children: <Widget>[
                              Text('Leash Required'),
                              Padding(padding: EdgeInsets.only(top: 8),),
                              Text(record['leashNeeded'] ? 'Yes' : 'No')
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Column(
                            children: <Widget>[
                              Text('Availability'),
                              Padding(padding: EdgeInsets.only(top: 8),),
                              Text('${record['availability']}')
                            ],
                          ),
                          
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12)
                    ),
                    Text('${record['status']}'),
                    Padding(padding: EdgeInsets.only(top: 12),),
                    Text('${record['description']}')
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: postsRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    DocumentSnapshot record = snapshot.data.documents[index];
                    String recordId = record.documentID;


                    if (userFavorites.contains(recordId)) {
                      return buildPostPet(record, record['imageURL']);
                    } else
                      return Container();
                  });
            }
          }),
    );
  }
}
