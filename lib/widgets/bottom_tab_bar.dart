import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomTabBar extends StatefulWidget {
  final bool darkMode;
  final String userId;
  final List<Widget> icons;
  final List<Widget> pages;
  final int numPages;

  BottomTabBar(
      {Key key,
      this.userId,
      this.icons,
      this.pages,
      this.numPages,
      this.darkMode})
      : super(key: key);
  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    getCurrentTab();
    if(_currentIndex == null) {
      _currentIndex = 0;
    }
  }

  void getCurrentTab() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentIndex = prefs.getInt('index') ?? 0;
  }

  void changeTabs(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      _currentIndex = index;
      await prefs.setInt('index', _currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _currentIndex,
      length: widget.numPages,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          onTap: changeTabs,
          indicatorColor: widget.darkMode ? Colors.black : Colors.white,
          labelColor: Theme.of(context).primaryColor,
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
