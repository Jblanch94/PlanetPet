import 'package:flutter/material.dart';
import 'package:planet_pet/screens/add_pet.dart';
import 'package:planet_pet/screens/admin_grid.dart';
import 'package:planet_pet/widgets/bottom_tab_bar.dart';

class AdminBottomTabBar extends StatefulWidget {
  final String userId;
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;

  const AdminBottomTabBar(
      {Key key, this.userId, this.darkMode, this.toggleTheme, this.signOut})
      : super(key: key);
  @override
  _AdminBottomTabBarState createState() => _AdminBottomTabBarState();
}

class _AdminBottomTabBarState extends State<AdminBottomTabBar> {
  @override
  Widget build(BuildContext context) {
    return BottomTabBar(
      // icons: <Widget>[Icon(Icons.camera_alt), Icon(Icons.whatshot)],
      icons: <Widget>[
        Icon(Icons.whatshot),
        Icon(Icons.camera_alt),
      ],
      pages: <Widget>[
        AdminGrid(
            userId: widget.userId,
            darkMode: widget.darkMode,
            toggleTheme: widget.toggleTheme,
            signOut: widget.signOut),
        PetForm(
            userId: widget.userId,
            darkMode: widget.darkMode,
            toggleTheme: widget.toggleTheme,
            signOut: widget.signOut),
      ],
      numPages: 2,
      darkMode: widget.darkMode,
    );
  }
}
