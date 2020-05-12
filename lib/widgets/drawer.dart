import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;
  final DocumentSnapshot user;
  final bool detailsPage;
  const SettingsDrawer({Key key, this.detailsPage, this.darkMode, this.toggleTheme, this.user, this.signOut}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text('Dark Mode'),
              value: darkMode,
              onChanged: toggleTheme,
            ),
          ],
        ),
      );
  }
}