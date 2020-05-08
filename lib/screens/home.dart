import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planet_pet/models/user.dart';
import 'package:planet_pet/screens/create_account_details.dart';
import 'package:planet_pet/widgets/not_auth_screen.dart';
import 'package:planet_pet/widgets/admin_bottom_tab_bar.dart';
import 'package:planet_pet/widgets/user_bottom_tab_bar.dart';

class Home extends StatefulWidget {

  final bool darkMode;
  final Function(bool) toggleTheme;

  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  Home({Key key, this.darkMode, this.toggleTheme}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isAuth = false;
  GoogleSignInAccount currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference usersRef = Firestore.instance.collection('users');
  User user;
  bool isAdmin;
  bool darkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      //ternary that displays screens if user is authenticated or not
      body: _isAuth ? authScreen() : NotAuthScreen(signIn: signIn),
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
    if (currentUser != null) {
      signInOnStart();
    }
  }

  //helper function that gets the admin status of the current user
  void getAdminStatus() async {
    DocumentSnapshot userDoc = await usersRef.document(currentUser.id).get();
    setState(() {
      isAdmin = userDoc['isAdmin'];
    });
  }

  //function that sets the state of authentication and updates the current users's account information
  void handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      setState(() {
        _isAuth = true;
        currentUser = account;
      });
      createUser();
      getAdminStatus();
      isAdmin = false;
      setState(() {});
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
          builder: (context) =>
              CreateAccountDetails(currentUserName: currentUser.displayName),
        ),
      );

      print(newUser == null);

      if (newUser != null) {
        setState(() {
          _isAuth = true;
        });
      } else {
        setState(() {
          _isAuth = false;
          _googleSignIn.signOut();
        });
      }
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
        'Adopted Pets': null,
        'prefsAnimalType': 0,
        'prefsCatBreeds': 0,
        'prefsDogBreeds': 0,
        'prefsOtherBreeds': 0,
        'prefsAnimalSex': 0,
        'prefsGoodHumans': null,
        'prefsGoodAnimals': null,
        'prefsNeedLeash': null,
        'prefsAvailability': 0,
        'favorites': [],
      });
    }
  }

  Widget authScreen() {
    return isAdmin
        ? AdminBottomTabBar()
        : UserBottomTabBar(userId: currentUser.id, darkMode: widget.darkMode, toggleTheme: widget.toggleTheme);
  }
}
