import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotAuthScreen extends StatefulWidget {
  final Function signIn;

  NotAuthScreen({Key key, this.signIn}) : super(key: key);
  @override
  _NotAuthScreenState createState() => _NotAuthScreenState();
}

class _NotAuthScreenState extends State<NotAuthScreen> {
  bool darkMode;

  @override
  void initState() {
    super.initState();
    getTheme();
    if (darkMode == null) {
      darkMode = false;
    }
  }

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    darkMode = prefs.getBool('darkMode') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            
            Icons.pets,
            size: orientation == Orientation.portrait
                ? height * 0.05
                : width * 0.05,
            color: Theme.of(context).iconTheme.color,
          ),
          Text(
            'Planet Pet',
            style: TextStyle(
              fontSize: orientation == Orientation.portrait
                  ? height * 0.065
                  : width * 0.065,
              fontWeight: FontWeight.w800,
              fontFamily: 'Indie Flower',
              fontStyle: FontStyle.italic,
            ),
          ),
          Container(
            width: orientation == Orientation.portrait
                ? height * 0.45
                : width * 0.50,
            height: orientation == Orientation.portrait
                ? height * 0.12
                : width * 0.15,
            child: GestureDetector(
              onTap: widget.signIn,
              child: Image.asset('assets/images/google_signin_button.png'),
            ),
          ),
        ],
      ),
    );
  }
}
