import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planet_pet/widgets/custom_scaffold.dart';

class FavoriteAnimals extends StatefulWidget {
  final String userId;
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;

  const FavoriteAnimals(
      {Key key, this.userId, this.darkMode, this.toggleTheme, this.signOut})
      : super(key: key);

  @override
  _FavoriteAnimalsState createState() => _FavoriteAnimalsState();
}

class _FavoriteAnimalsState extends State<FavoriteAnimals> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  CollectionReference usersRef = Firestore.instance.collection('users');
  CollectionReference postsRef = Firestore.instance.collection('pets');
  dynamic userFavorites;
  Stream<QuerySnapshot> snapshot;
  DocumentSnapshot userDoc;
  bool isExpanded;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserFavorites();
    if (userFavorites == null) {
      userFavorites = [];
    }
    getSnapshot();
  }

  void getUserDetails() {}

  void getSnapshot() {
    setState(() {
      snapshot = postsRef.snapshots();
    });
  }

  void fetchCurrentUserFavorites() async {
    userDoc = await usersRef.document(widget.userId).get();

    final docs = userDoc.data['favorites'];
    userFavorites = docs;
    if (this.mounted) {
      setState(() {
        userFavorites = docs;
      });
    }
  }

  //TODO: Need to update will make it responsive when I do that
  Widget buildPostPet(dynamic record, String url, BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Semantics(
      child: cardContainer(url, record, orientation, width, height),
    );
  }

  Widget cardContainer(String url, dynamic record, Orientation orientation,
      double width, double height) {
    return Card(
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                url,
                fit: BoxFit.cover,
              ),
            ),
            ExpansionTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(url),
                radius: 30,
              ),
              title: Text('${record['name']}'),
              subtitle: Text('Details'),
              trailing: Icon(Icons.expand_more),
              children: <Widget>[
                ListTile(
                    dense: true,
                    leading: Text('Name'),
                    title: Text('${record['name']}')),
                ListTile(
                    dense: true,
                    leading: Text('Type'),
                    title: Text('${record['animalType']}')),
                ListTile(
                    dense: true,
                    leading: Text('Breed'),
                    title: Text('${record['breed']}')),
                ListTile(
                    dense: true,
                    leading: Text('Gender'),
                    title: Text('${record['sex']}')),
                ListTile(
                  dense: true,
                  title: Text(record['goodAnimals']
                      ? 'Good with Other Animals'
                      : 'Not Good with Other Animals'),
                ),
                ListTile(
                  dense: true,
                  title: Text(record['goodChildren']
                      ? 'Good with Children'
                      : 'Not Good with Children'),
                ),
                ListTile(
                  dense: true,
                  title: Text(record['leashNeeded']
                      ? 'Leash Required'
                      : 'Leash not Required'),
                ),
                ListTile(
                  dense: true,
                  title: Text('${record['status']}'),
                ),
                ListTile(
                  dense: true,
                  title: Text('${record['description']}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      detailsPage: false,
      user: userDoc,
      signOut: widget.signOut,
      scaffoldKey: _scaffoldKey,
      darkMode: widget.darkMode,
      toggleTheme: widget.toggleTheme,
      title: 'Favorite Pets',
      body: StreamBuilder(
          stream: snapshot,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    DocumentSnapshot record = snapshot.data.documents[index];
                    String recordId = record.documentID;

                    if (userFavorites.contains(recordId)) {
                      return buildPostPet(record, record['imageURL'], context);
                    } else if (userFavorites == null) {
                      return Text('No favorited animals.');
                    } else
                      return Container();
                  });
            }
          }),
    );
  }
}
