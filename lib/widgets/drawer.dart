import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingsDrawer extends StatefulWidget {
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;
  final DocumentSnapshot user;
  final bool detailsPage;
  const SettingsDrawer({Key key, this.detailsPage, this.darkMode,
      this.toggleTheme, this.user, this.signOut}) : super(key: key);

  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final CollectionReference usersRef = Firestore.instance.collection('users');
  TextEditingController controller = TextEditingController();
  String userId;
  var userMap = new Map();

  void initState() {
    super.initState();
    userMap['username'] = widget.user.data['username'];
    userMap['phoneNumber'] = widget.user.data['phoneNumber'];
    userMap['streetAddress1'] = widget.user.data['streetAddress1'];
    userMap['streetAddress2'] = widget.user.data['streetAddress2'];
    userMap['city'] = widget.user.data['city'];
    userMap['state'] = widget.user.data['state'];
    userMap['zipcode'] = widget.user.data['zipcode'];
    getUserID();
  }

  void getUserID() async {
    userId = await widget.user.data['userId'];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Hello, ' + userMap['username'])
          ),
          Divider(height: 0),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: widget.darkMode,
            onChanged: widget.toggleTheme,
          ),
          Divider(height: 0),
          userInformation(context),
        ],
      ),
    );
  }

  Widget userInformation(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('User Information')
        ),
        ListTile(
          title: Text(userMap['phoneNumber']),
          subtitle: Text('Phone Number'),
          trailing: Icon(Icons.edit),
          dense: true,
          onTap: () {
            editUserInfo(context, 'Phone Number', 'phoneNumber');
          }
        ),
        ListTile(
          title: Text(userMap['streetAddress1']),
          subtitle: Text('Street Address 1'),
          trailing: Icon(Icons.edit),
          dense: true,
          onTap: () {
            editUserInfo(context, 'Street Address 1', 'streetAddress1');
          }
        ),
        ListTile(
          title: Text(userMap['streetAddress2']),
          subtitle: Text('Street Address 2'),
          trailing: Icon(Icons.edit),
          dense: true,
          onTap: () {
            editUserInfo(context, 'Street Address 2', 'streetAddress2');
          }
        ),
        ListTile(
          title: Text(userMap['city']),
          subtitle: Text('City'),
          trailing: Icon(Icons.edit),
          dense: true,
          onTap: () {
            editUserInfo(context, 'City', 'city');
          }
        ),
        ListTile(
          title: Text(userMap['state']),
          subtitle: Text('State'),
          trailing: Icon(Icons.edit),
          dense: true,
          onTap: () {
            editUserInfo(context, 'State', 'state');
          }
        ),
        ListTile(
          title: Text(userMap['zipcode']),
          subtitle: Text('Zip Code'),
          trailing: Icon(Icons.edit),
          dense: true,
          onTap: () {
            editUserInfo(context, 'Zipcode', 'zipcode');
          }
        ),
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
                usersRef.document(userId).setData({
                  key: controller.text.toString(),
                }, merge: true);
                setState(() {
                  userMap[key] = controller.text.toString();
                });
                controller.clear();
                
                Navigator.of(context).pop(controller.text.toString());
              },
              child: Text('Submit')
            )
          ],
        );
      }
    );
  }
}