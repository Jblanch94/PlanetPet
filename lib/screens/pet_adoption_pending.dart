import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planet_pet/widgets/custom_scaffold.dart';

class PetAdoptionPending extends StatefulWidget {
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;
  final dynamic petDoc;
  final DocumentSnapshot userDoc;

  const PetAdoptionPending(
      {Key key,
      this.darkMode,
      this.toggleTheme,
      this.signOut,
      this.petDoc,
      this.userDoc})
      : super(key: key);

  @override
  _PetAdoptionPendingState createState() => _PetAdoptionPendingState();
}

class _PetAdoptionPendingState extends State<PetAdoptionPending> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print('${widget.petDoc}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //scaffoldKey: _scaffoldKey,
      appBar: AppBar(
        title: Text("${widget.petDoc['name']}"),
        centerTitle: true,
      ),
      // darkMode: widget.darkMode,
      // toggleTheme: widget.toggleTheme,
      // signOut: widget.signOut,
      // user: widget.userDoc,
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            CircleAvatar(
              radius: 70,
              backgroundImage:
                  CachedNetworkImageProvider(widget.petDoc['imageURL']),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16,
              ),
            ),
            Text(
              widget.petDoc['name'],
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            Text(
              'Adoption Pending!',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            Text('Call to confirm visit at (999)999-9999'),
            Padding(padding: EdgeInsets.only(top: 16)),
            Text(
              'Email to confirm visit at example@gmail.com',
            ),
          ],
        ),
      ),
    );
  }
}
