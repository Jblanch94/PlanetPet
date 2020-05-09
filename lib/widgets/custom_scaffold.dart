import 'package:flutter/material.dart';
import 'package:planet_pet/widgets/drawer.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final GlobalKey scaffoldKey;
  final String title;
  final bool darkMode;
  final Function(bool) toggleTheme;
  const CustomScaffold(
      {Key key,
      this.body,
      this.scaffoldKey,
      this.title,
      this.darkMode,
      this.toggleTheme})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      key: scaffoldKey,
      endDrawer: SettingsDrawer(darkMode: darkMode, toggleTheme: toggleTheme),
      appBar: AppBar(
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
