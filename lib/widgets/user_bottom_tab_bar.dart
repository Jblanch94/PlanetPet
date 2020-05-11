import 'package:flutter/material.dart';
import 'package:planet_pet/screens/favorite_animals.dart';
import 'package:planet_pet/screens/posts.dart';
import 'package:planet_pet/screens/preferences.dart';
import 'package:planet_pet/widgets/bottom_tab_bar.dart';

class UserBottomTabBar extends StatefulWidget {
  final String userId;
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;

  const UserBottomTabBar(
      {Key key, this.userId, this.darkMode, this.toggleTheme, this.signOut})
      : super(key: key);

  @override
  _UserBottomTabBarState createState() => _UserBottomTabBarState();
}

class _UserBottomTabBarState extends State<UserBottomTabBar> {
  @override
  Widget build(BuildContext context) {
    return BottomTabBar(icons: <Widget>[
      Icon(Icons.home),
      Icon(Icons.search),
      Icon(Icons.favorite),
    ], pages: <Widget>[
      Posts(
          userId: widget.userId,
          darkMode: widget.darkMode,
          toggleTheme: widget.toggleTheme,
          signOut: widget.signOut),
      Preferences(
          userId: widget.userId,
          darkMode: widget.darkMode,
          toggleTheme: widget.toggleTheme,
          signOut: widget.signOut),
      FavoriteAnimals(
          userId: widget.userId,
          darkMode: widget.darkMode,
          toggleTheme: widget.toggleTheme,
          signOut: widget.signOut),
    ], numPages: 3, darkMode: widget.darkMode);
  }
}
