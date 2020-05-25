import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planet_pet/screens/admin_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:planet_pet/widgets/custom_scaffold.dart';

Widget _buildGridItem(
    BuildContext context,
    DocumentSnapshot document,
    bool darkMode,
    void Function(bool) toggleTheme,
    void Function() signOut,
    DocumentSnapshot userDoc,
    Orientation orientation,
    double width,
    double height) {
  return GestureDetector(
    child: Semantics(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: orientation == Orientation.portrait
                    ? height * 0.025
                    : width * 0.025),
              ),
              Semantics(
                  child: CircleAvatar(
                    radius: orientation == Orientation.portrait
                        ? height * 0.08
                        : width * 0.09,
                    backgroundImage: CachedNetworkImageProvider(
                      document['imageURL'],
                    ),
                  ),
                  image: true,
                  label: "Image of ${document['name']}",
                  hint: "Image of ${document['name']}"),
              Padding(
                padding: EdgeInsets.only(
                    top: orientation == Orientation.portrait
                        ? height * 0.02
                        : width * 0.015),
              ),
              Column(
                children: <Widget>[
                  Text(
                    document['name'],
                    style: TextStyle(
                      fontSize: orientation == Orientation.portrait
                          ? height * 0.03
                          : width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    document['breed'],
                    style: TextStyle(
                      fontSize: orientation == Orientation.portrait
                          ? height * 0.03
                          : width * 0.03,
                    ),
                  ),
                  Text(
                    document['availability'],
                    style: TextStyle(
                      fontSize: orientation == Orientation.portrait
                          ? height * 0.025
                          : width * 0.02,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        label: "Card for ${document['name']}",
        hint: "Card for ${document['name']}"),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AdminDetailPage(
                document: document,
                darkMode: darkMode,
                toggleTheme: toggleTheme,
                signOut: signOut,
                userDoc: userDoc) // AdminDetailPage(document: document)
            ),
      );
    },
  );
}

class AdminGrid extends StatefulWidget {
  final String userId;
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;
  const AdminGrid(
      {Key key, this.userId, this.darkMode, this.toggleTheme, this.signOut})
      : super(key: key);

  @override
  _AdminGridState createState() => _AdminGridState();
}

class _AdminGridState extends State<AdminGrid> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  CollectionReference usersRef = Firestore.instance.collection('users');
  DocumentSnapshot userDoc;

  void getUserDetails() async {
    userDoc = await usersRef.document(widget.userId).get();
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomScaffold(
      user: userDoc,
      detailsPage: false,
      signOut: widget.signOut,
      scaffoldKey: _scaffoldKey,
      darkMode: widget.darkMode,
      toggleTheme: widget.toggleTheme,
      title: 'Pets',
      body: StreamBuilder(
          stream: Firestore.instance.collection('pets').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                childAspectRatio:
                    orientation == Orientation.landscape ? 10 / 10 : 7 / 9,
              ),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => _buildGridItem(
                  context,
                  snapshot.data.documents[index],
                  widget.darkMode,
                  widget.toggleTheme,
                  widget.signOut,
                  userDoc,
                  orientation,
                  width,
                  height),
            );
          }),
    );
  }
}
