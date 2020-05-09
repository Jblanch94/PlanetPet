import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planet_pet/screens/admin_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:planet_pet/widgets/drawer.dart';

Widget _buildGridItem(BuildContext context, DocumentSnapshot document) {
  return GestureDetector(
    child: Card(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: CachedNetworkImageProvider(
              document['imageURL'],
            ),
          ),
          SizedBox(height: 20),
          Text(document['name'], style: TextStyle(fontSize: 14)),
          Text(document['breed'], style: TextStyle(fontSize: 14)),
          Text(document['availability'], style: TextStyle(fontSize: 14)),
        ],
      ),
    ),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AdminDetailPage(
                  document) // AdminDetailPage(document: document)
              ));
    },
  );
}

class AdminGrid extends StatefulWidget {
  final bool darkMode;
  final Function(bool) toggleTheme;
  const AdminGrid({Key key, this.darkMode, this.toggleTheme}) : super(key: key);

  @override
  _AdminGridState createState() => _AdminGridState();
}

class _AdminGridState extends State<AdminGrid> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SettingsDrawer(
          darkMode: widget.darkMode, toggleTheme: widget.toggleTheme),
      appBar: AppBar(
        title: Text('Pets'),
        centerTitle: true,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('pets').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildGridItem(context, snapshot.data.documents[index]),
            );
          }),
    );
  }
}
