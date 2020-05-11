import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planet_pet/models/user.dart';

class SettingsDrawer extends StatelessWidget {
  final bool darkMode;
  final Function(bool) toggleTheme;
  final DocumentSnapshot user;
  const SettingsDrawer({Key key, this.darkMode, this.toggleTheme, this.user})
      : super(key: key);
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
                    title: Text(user['username']),
                  ),
                  Divider(),
                  ListTile(
                    leading: Platform.isAndroid
                        ? Icon(Icons.phone_android)
                        : Icon(Icons.phone_iphone),
                    title: Text(user['phoneNumber']),
                  ),
                  Divider(),
                  ListTile(
                    dense: true,
                    leading: Text('Street Address 1:'),
                    title: Text(user['streetAddress1']),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Street Address 2/Apartment:'),
                    title: Text(user['streetAddress2']),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('City:'),
                    title: Text(user['city']),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('State:'),
                    title: Text(user['state']),
                  ),
                  ListTile(
                    dense: true,
                    leading: Text('Zip code:'),
                    title: Text(user['zipcode']),
                  ),
                ],
              ),
            ),
          ),
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
