import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsDrawer extends StatefulWidget {
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;
  final DocumentSnapshot user;
  const SettingsDrawer({Key key, this.darkMode, this.toggleTheme, this.user, this.signOut})
      : super(key: key);

  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Scrollbar(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.person),
                    title: Text(widget.user['username']),
                  ),
                  Divider(),
                  ListTile(
                    leading: Platform.isAndroid
                        ? Icon(Icons.phone_android)
                        : Icon(Icons.phone_iphone),
                    title: Text(widget.user['phoneNumber']),
                  ),
                  Divider(),
                  ListTile(
                    dense: true,
                    leading: Text('Street Address 1:'),
                    title: Text(widget.user['streetAddress1']),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Street Address 2/Apartment:'),
                    title: Text(widget.user['streetAddress2']),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('City:'),
                    title: Text(widget.user['city']),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('State:'),
                    title: Text(widget.user['state']),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Zip code:'),
                    title: Text(widget.user['zipcode']),
                  ),
                ],
              ),
            ),
          ),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: widget.darkMode,
            onChanged: widget.toggleTheme,
          ),
          RaisedButton(
            child: Text('Sign Out'),
            onPressed: () {
              Navigator.of(context).pop();
              widget.signOut();
            },
          ),
        ],
      ),
    );
  }
}
