import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isAuth = false;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isAuth ? authScreen() : notAuthScreen(),
    );
  }

  void signIn() async {
    await _googleSignIn.signIn();
  }

  @override 
  void initState() {
    super.initState();
    _googleSignIn.signOut();
  }

  Container notAuthScreen() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Planet Pet',
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
              onTap: signIn,
              child: Image.asset('assets/images/google_signin_button.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget authScreen() {
    return Text('Authenticated');
  }
}
