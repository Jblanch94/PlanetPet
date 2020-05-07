import 'package:flutter/material.dart';
import 'package:planet_pet/screens/add_pet.dart';
import 'package:planet_pet/screens/admin_grid.dart';
import 'package:planet_pet/widgets/bottom_tab_bar.dart';

class AdminBottomTabBar extends StatefulWidget {
  @override
  _AdminBottomTabBarState createState() => _AdminBottomTabBarState();
}

class _AdminBottomTabBarState extends State<AdminBottomTabBar> {
  @override
  Widget build(BuildContext context) {
    return BottomTabBar(
      icons: <Widget>[Icon(Icons.camera_alt), Icon(Icons.whatshot)],
      pages: <Widget>[PetForm(), AdminGrid()],
      numPages: 2
    );
  }
}
