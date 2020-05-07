import 'package:flutter/material.dart';

class BottomTabBar extends StatefulWidget {
  final String userId;
  final List<Widget> icons;
  final List<Widget> pages;
  final int numPages;

  BottomTabBar({Key key, this.userId, this.icons, this.pages, this.numPages})
      : super(key: key);
  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.numPages,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: widget.icons,
        ),
        body: TabBarView(
          children: widget.pages,
        ),
      ),
    );
  }
}
