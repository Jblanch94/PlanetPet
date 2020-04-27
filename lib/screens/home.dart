import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planet_pet/models/user.dart';
import 'package:planet_pet/widgets/bottom_tab_bar.dart';
import 'package:planet_pet/screens/create_account_details.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isAuth = false;
  GoogleSignInAccount currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference usersRef = Firestore.instance.collection('users');
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ternary that displays screens if user is authenticated or not
      body: _isAuth ? authScreen() : notAuthScreen(),
    );
  }

  //sign user in
  void signIn() async {
    await _googleSignIn.signIn();
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.signOut();

    //listen for a change in user account
    _googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('$err');
    });
    signInOnStart();
  }

  //function that sets the state of authentication and updates the current users's account information
  void handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      setState(() {
        _isAuth = true;
        currentUser = account;
      });
      createUser();
      print(user);
    } else {
      setState(() {
        _isAuth = false;
      });
    }
  }

  //signs in user on start of application
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

  void createUser() async {
    DocumentSnapshot doc = await usersRef.document(currentUser.id).get();

    //check if document exists by using the user id as the document id
    //if user does not exist then navigate to create account page
    if (!doc.exists) {
      final User newUser = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CreateAccountDetails(currentUserName: currentUser.displayName),
        ),
      );
      //send to firebase with new user
      usersRef.document(currentUser.id).setData({
        'username': currentUser.displayName,
        'userId': currentUser.id,
        'email': currentUser.email,
        'isAdmin': false,
        'phoneNumber': newUser.phoneNumber,
        'latitude': newUser.latitude,
        'longitude': newUser.longitude,
        'streetAddress1': newUser.streetAddress1,
        'streetAddress2': newUser.streetAddress2,
        'city': newUser.city,
        'state': newUser.state,
        'zipcode': newUser.zipcode,
        'favorites': null,
        'Adopted Pets': null
      });
    }

    //otherwise proceed as normal and save details of user
    // we might need to pass down user detail to other pages
    setState(() {
      user = User.fromDocument(doc);
    });
  }

  BottomTabBar authScreen() {
    return BottomTabBar();
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
}
