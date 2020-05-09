import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
  final bool darkMode;
  final Function(bool) toggleTheme;
  SettingsDrawer({Key key, this.darkMode, this.toggleTheme}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text('DarkMode'),
              value: darkMode,
              onChanged: toggleTheme,
            ),
          ],
        ),
      );
  }
}