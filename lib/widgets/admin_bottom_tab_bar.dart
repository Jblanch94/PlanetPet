import 'package:flutter/material.dart';
import 'package:planet_pet/screens/add_pet.dart';
import 'package:planet_pet/screens/admin_grid.dart';
import 'package:planet_pet/widgets/bottom_tab_bar.dart';

class AdminBottomTabBar extends StatefulWidget {
  final bool darkMode;
  final Function(bool) toggleTheme;

  const AdminBottomTabBar({Key key, this.darkMode, this.toggleTheme})
      : super(key: key);
  @override
  _AdminBottomTabBarState createState() => _AdminBottomTabBarState();
}

class _AdminBottomTabBarState extends State<AdminBottomTabBar> {
  @override
  Widget build(BuildContext context) {
    return BottomTabBar(
      icons: <Widget>[Icon(Icons.camera_alt), Icon(Icons.whatshot)],
      pages: <Widget>[
        PetForm(darkMode: widget.darkMode, toggleTheme: widget.toggleTheme),
        AdminGrid(darkMode: widget.darkMode, toggleTheme: widget.toggleTheme)
      ],
      numPages: 2,
      darkMode: widget.darkMode,
    );
  }
}
