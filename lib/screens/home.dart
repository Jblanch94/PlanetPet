import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isAuth = false;
  GoogleSignInAccount currentUser;
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
    _googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('$err');
    });
    signInOnStart();
  }

  void handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      setState(() {
        _isAuth = true;
        currentUser = account;
      });
    } else {
      setState(() {
        _isAuth = false;
      });
    }
  }

  void signInOnStart() async {
    try {
      final GoogleSignInAccount _authOnStart =
          await _googleSignIn.signInSilently();
      handleSignIn(_authOnStart);
      print(currentUser.displayName);
    } catch (err) {
      print('$err');
    }
  }

  Container notAuthScreen() {
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
