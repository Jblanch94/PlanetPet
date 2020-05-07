import 'package:flutter/material.dart';
import 'package:planet_pet/screens/favorite_animals.dart';
import 'package:planet_pet/screens/posts.dart';
import 'package:planet_pet/screens/preferences.dart';
import 'package:planet_pet/widgets/bottom_tab_bar.dart';

class UserBottomTabBar extends StatefulWidget {
  final String userId;

  UserBottomTabBar({this.userId});

  @override
  _UserBottomTabBarState createState() => _UserBottomTabBarState();
}

class _UserBottomTabBarState extends State<UserBottomTabBar> {
  @override
  Widget build(BuildContext context) {
    return BottomTabBar(
      icons: <Widget>[
        Icon(Icons.home),
        Icon(Icons.settings_applications),
        Icon(Icons.favorite),
      ],
      pages: <Widget>[
        Posts(userId: widget.userId),
        Preferences(userId: widget.userId),
        FavoriteAnimals(userId: widget.userId),
      ],
      numPages: 3
    );
  }
}
