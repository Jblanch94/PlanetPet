import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planet_pet/models/user.dart';
import 'package:planet_pet/widgets/drawer.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final GlobalKey scaffoldKey;
  final String title;
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;
  final DocumentSnapshot user;
   CustomScaffold(
      {Key key,
      this.body,
      this.scaffoldKey,
      this.title,
      this.darkMode,
      this.toggleTheme, this.user, this.signOut})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      key: scaffoldKey,
      endDrawer: SettingsDrawer(darkMode: darkMode, toggleTheme: toggleTheme, user: user, signOut: signOut),
      appBar: AppBar(
        leading: RaisedButton(
          child: Text('Sign Out'),
          onPressed: ()  {
            print('tapped');
            signOut();
            },
        ),
        title: Text(title),
        centerTitle: true,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }
}
