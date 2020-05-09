import 'package:flutter/material.dart';
import 'package:planet_pet/screens/favorite_animals.dart';
import 'package:planet_pet/screens/posts.dart';
import 'package:planet_pet/screens/preferences.dart';
import 'package:planet_pet/widgets/bottom_tab_bar.dart';

class UserBottomTabBar extends StatefulWidget {
  final String userId;
  final bool darkMode;
  final Function(bool) toggleTheme;

  const UserBottomTabBar({Key key, this.userId, this.darkMode, this.toggleTheme}) : super(key: key);

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
        Posts(userId: widget.userId, darkMode: widget.darkMode, toggleTheme: widget.toggleTheme),
        Preferences(userId: widget.userId, darkMode: widget.darkMode, toggleTheme: widget.toggleTheme),
        FavoriteAnimals(userId: widget.userId, darkMode: widget.darkMode, toggleTheme: widget.toggleTheme),
      ],
      numPages: 3,
      darkMode: widget.darkMode
    );
  }
}
