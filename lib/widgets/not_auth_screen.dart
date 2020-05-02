import 'package:flutter/material.dart';

class NotAuthScreen extends StatefulWidget {

  final  Function signIn;

  NotAuthScreen({Key key, this.signIn}) : super(key: key);
  @override
  _NotAuthScreenState createState() => _NotAuthScreenState();
}

class _NotAuthScreenState extends State<NotAuthScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Planet Pet',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              fontFamily: 'Indie Flower',
              fontStyle: FontStyle.italic,
            ),
          ),
          Container(
            width: 280,
            height: 120,
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