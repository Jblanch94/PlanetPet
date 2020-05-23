import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:planet_pet/screens/pet_detail_page.dart';
import 'package:planet_pet/widgets/custom_scaffold.dart';

List<String> animalTypes = ['None', 'Cat', 'Dog', 'Other'];
List<String> catBreeds = ['None', 'Persian', 'Shorthair', 'Himalayan'];
List<String> dogBreeds = [
  'None',
  'Golden Retriever',
  'German Shepherd',
  'Beagle',
  'Poodle'
];
List<String> otherBreeds = ['None', 'Bird', 'Frog', 'Lizard', 'Snake'];
List<String> animalSexes = ['None', 'Male', 'Female'];
List<String> availability = [
  'None',
  'Available',
  'Pending Adoption',
  'Adopted'
];

class Posts extends StatefulWidget {
  final String userId;
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;
  const Posts(
      {Key key, this.userId, this.darkMode, this.toggleTheme, this.signOut})
      : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final CollectionReference postsRef = Firestore.instance.collection('pets');
  final CollectionReference usersRef = Firestore.instance.collection('users');
  Stream<QuerySnapshot> snapshot;
  DocumentSnapshot doc;

  String _animalType;
  String _catBreeds;
  String _dogBreeds;
  String _otherBreeds;
  String _animalSex;
  bool goodHumans = true;
  bool goodAnimals = true;
  bool needLeash = true;
  String _availability;

  void initState() {
    super.initState();
    initSearchPreferences();
    if (_animalType == null) {
      _animalType = 'None';
      _catBreeds = 'None';
      _dogBreeds = 'None';
      _otherBreeds = 'None';
      _animalSex = 'None';
      _availability = 'None';
    }
    getSnapshot();
    getUserDetails();
  }

  void getSnapshot() {
    snapshot = postsRef.snapshots();
  }

  void getUserDetails() async {
    doc = await usersRef.document(widget.userId).get();
    setState(() {});
  }

  void initSearchPreferences() async {
    DocumentSnapshot userDoc = await usersRef.document(widget.userId).get();

    setState(() {
      _animalType = animalTypes[userDoc.data['prefsAnimalType']] ?? 'None';
      _catBreeds = catBreeds[userDoc.data['prefsCatBreeds']] ?? 'None';
      _dogBreeds = dogBreeds[userDoc.data['prefsDogBreeds']] ?? 'None';
      _otherBreeds = otherBreeds[userDoc.data['prefsOtherBreeds']] ?? 'None';
      _animalSex = animalSexes[userDoc.data['prefsAnimalSex']] ?? 'None';
      goodHumans = userDoc.data['prefsGoodHumans'] ?? true;
      goodAnimals = userDoc.data['prefsGoodAnimals'] ?? true;
      needLeash = userDoc.data['prefsNeedLeash'] ?? true;
      _availability = availability[userDoc.data['prefsAvailability']] ?? 'None';
    });
  }

  void viewPetDetails(BuildContext context, dynamic petDoc, dynamic docId) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PetDetailPage(
            petDoc: petDoc,
            userId: widget.userId,
            docId: docId,
            darkMode: widget.darkMode,
            userDoc: doc,
            toggleTheme: widget.toggleTheme,
            signOut: widget.signOut)));
  }

  bool matchesSearchPrefs(var petDoc) {
    if (petDoc['animalType'] != _animalType && _animalType != 'None') {
      return false;
    } else if (petDoc['goodChildren'] != goodHumans && goodHumans != null) {
      return false;
    } else if (petDoc['goodAnimals'] != goodAnimals && goodAnimals != null) {
      return false;
    } else if (petDoc['leashNeeded'] != needLeash && needLeash != null) {
      return false;
    } else if (petDoc['sex'] != _animalSex && _animalSex != 'None') {
      return false;
    } else if (petDoc['availability'] != _availability &&
        _availability != 'None') {
      return false;
    } else {
      if (petDoc['animalType'] == 'Cat' &&
          petDoc['breed'] != _catBreeds &&
          _catBreeds != 'None') {
        return false;
      } else if (petDoc['animalType'] == 'Dog' &&
          petDoc['breed'] != _dogBreeds &&
          _dogBreeds != 'None') {
        return false;
      } else if (petDoc['animalType'] == 'Other' &&
          petDoc['breed'] != _otherBreeds &&
          _otherBreeds != 'None') {
        return false;
      } else {
        return true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomScaffold(
      detailsPage: false,
      user: doc,
      scaffoldKey: _scaffoldKey,
      darkMode: widget.darkMode,
      toggleTheme: widget.toggleTheme,
      title: 'Pets',
      signOut: widget.signOut,
      body: StreamBuilder(
          stream: snapshot,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<DocumentSnapshot> displayedAnimals = [];
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              var petDoc = snapshot.data.documents[i];
              if (matchesSearchPrefs(petDoc)) {
                displayedAnimals.add(petDoc);
              }
            }
            if (displayedAnimals == []) {
              displayedAnimals = snapshot.data.documents;
            }

            return Container(
              height: double.maxFinite,
              padding: orientation == Orientation.portrait
                  ? EdgeInsets.only(top: height * 0.05)
                  : EdgeInsets.only(top: width * 0.04),
              child: GridView.builder(
                  addRepaintBoundaries: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: orientation == Orientation.landscape
                          ? 11 / 10
                          : 7 / 9,
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 3),
                  itemCount: displayedAnimals.length,
                  itemBuilder: (_, index) {
                    var petDoc = displayedAnimals[index];
                    var docId = displayedAnimals[index].documentID;
                  
                    return Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => viewPetDetails(
                            context,
                            petDoc,
                            docId,
                          ),
                          child: Semantics(
                              child: CircleAvatar(
                                radius: orientation == Orientation.portrait
                                    ? height * 0.085
                                    : width * 0.075,
                                backgroundImage: CachedNetworkImageProvider(
                                  petDoc['imageURL'],
                                ),
                              ),
                              image: true,
                              label: "Image of ${petDoc['name']}",
                              hint: "Image of ${petDoc['name']}"),
                        ),
                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.only(top: height * 0.015)
                              : EdgeInsets.only(top: width * 0.0075),
                        ),
                        Text(petDoc['name']),
                        Text(
                              doc == null ? '' : "${(SphericalUtil.computeDistanceBetween(LatLng(petDoc['latitude'], petDoc['longitude']), LatLng(doc['latitude'], doc['longitude'])) / 1000 * .621371).round()} miles away"),
                      ],
                    );
                  }),
            );
          }),
    );
  }
}
