import 'package:flutter/material.dart';
import 'package:planet_pet/screens/add_pet.dart';
import 'package:planet_pet/screens/view_matches.dart';
import 'package:planet_pet/screens/posts.dart';
import 'package:planet_pet/screens/favorite_animals.dart';
import 'package:planet_pet/screens/preferences.dart';

class BottomTabBar extends StatefulWidget {
  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            Icon(Icons.home),
            Icon(Icons.settings_applications),
            Icon(Icons.favorite),
            Icon(Icons.camera_alt),
            Icon(Icons.whatshot)
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Posts(),
            Preferences(),
            FavoriteAnimals(),
            PetForm(),
            ViewMatches()
          ],
        ),
      ),
    );
  }
}
