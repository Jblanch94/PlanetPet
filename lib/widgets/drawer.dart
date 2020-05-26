import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsDrawer extends StatefulWidget {
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;
  final DocumentSnapshot user;
  final bool detailsPage;
  const SettingsDrawer(
      {Key key,
      this.detailsPage,
      this.darkMode,
      this.toggleTheme,
      this.user,
      this.signOut})
      : super(key: key);

  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final CollectionReference usersRef = Firestore.instance.collection('users');
  TextEditingController controller = TextEditingController();

  Map userMap = {};

  void initState() {
    super.initState();
    userMap['username'] = widget.user['username'];
    userMap['phoneNumber'] = widget.user['phoneNumber'];
    userMap['streetAddress1'] = widget.user['streetAddress1'];
    userMap['streetAddress2'] = widget.user['streetAddress2'];
    userMap['city'] = widget.user['city'];
    userMap['state'] = widget.user['state'];
    userMap['zipcode'] = widget.user['zipcode'];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: ListView(
              children: <Widget>[
                userInformation(context),
              ],
            ),
          ),
          Divider(),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: widget.darkMode,
            onChanged: widget.toggleTheme,
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  color: Theme.of(context).buttonTheme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 11,
                  child: Text(
                    'Sign out',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (widget.detailsPage) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      widget.signOut();
                    } else {
                      Navigator.of(context).pop();
                      widget.signOut();
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget userInformation(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person, color: Colors.white),
          title: Text(
            '${userMap['username']}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          dense: true,
        ),
        ListTile(
            title: Text(
              userMap['phoneNumber'],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            leading: Platform.isAndroid
                ? Icon(Icons.phone_android, color: Colors.white)
                : Icon(Icons.phone_iphone, color: Colors.white),
            trailing: Icon(Icons.edit, color: Colors.white),
            dense: true,
            onTap: () {
              editUserInfo(context, 'Phone Number', 'phoneNumber');
            }),
        ListTile(
            title: Text(
              userMap['streetAddress1'],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            leading: FaIcon(FontAwesomeIcons.houseUser, color: Colors.white),
            trailing: Icon(Icons.edit, color: Colors.white),
            dense: true,
            onTap: () {
              editUserInfo(context, 'Street Address 1', 'streetAddress1');
            }),
        ListTile(
            title: Text(
              userMap['streetAddress2'],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            leading: FaIcon(FontAwesomeIcons.building, color: Colors.white),
            trailing: Icon(Icons.edit, color: Colors.white),
            dense: true,
            onTap: () {
              editUserInfo(context, 'Street Address 2', 'streetAddress2');
            }),
        ListTile(
            title: Text(
              userMap['city'],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            leading: FaIcon(FontAwesomeIcons.city, color: Colors.white),
            trailing: Icon(Icons.edit, color: Colors.white),
            dense: true,
            onTap: () {
              editUserInfo(context, 'City', 'city');
            }),
        ListTile(
            title: Text(
              userMap['state'],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'state',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(Icons.edit, color: Colors.white),
            dense: true,
            onTap: () {
              editUserInfo(context, 'State', 'state');
            }),
        ListTile(
            title: Text(
              userMap['zipcode'],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'Zip Code',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(Icons.edit, color: Colors.white),
            dense: true,
            onTap: () {
              editUserInfo(context, 'Zipcode', 'zipcode');
            }),
      ],
    );
  }

  Future<String> editUserInfo(BuildContext context, String prompt, String key) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(prompt),
            content: TextField(
              keyboardType: key == 'phoneNumber' ? TextInputType.phone : null,
              controller: controller,
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  onPressed: () {
                    usersRef.document(widget.user['userId']).setData({
                      key: controller.text.toString(),
                    }, merge: true);
                    setState(() {
                      userMap[key] = controller.text.toString();
                    });
                    controller.clear();

                    Navigator.of(context).pop(controller.text.toString());
                  },
                  child: Text('Submit'))
            ],
          );
        });
  }
}
