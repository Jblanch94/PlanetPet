import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planet_pet/screens/pet_detail_page.dart';

List<String> animalTypes = ['None', 'Cat', 'Dog', 'Other'];
List<String> catBreeds = ['None', 'Persian', 'Shorthair', 'Himalayan'];
List<String> dogBreeds = ['None', 'Golden Retriever', 'German Shepherd', 'Beagle', 'Poodle'];
List<String> otherBreeds = ['None', 'Bird', 'Frog', 'Lizard', 'Snake'];
List<String> animalSexes = ['None', 'Male', 'Female'];
List<String> availability = ['None', 'Available', 'Pending Adoption', 'Adopted'];

class Posts extends StatefulWidget {
  final String userId;
  Posts({this.userId});

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final CollectionReference postsRef = Firestore.instance.collection('pets');
  final CollectionReference usersRef = Firestore.instance.collection('users');

  String _animalType;
  String _catBreeds;
  String _dogBreeds;
  String _otherBreeds;
  String _animalSex;
  bool goodHumans = null;
  bool goodAnimals = null;
  bool needLeash = null;
  String _availability;

  void initState() {
    super.initState();
    initSearchPreferences();
  }

  void initSearchPreferences() async {
    DocumentSnapshot userDoc = await usersRef.document(widget.userId).get();

    setState(() {
      _animalType = animalTypes[userDoc.data['prefsAnimalType']] ?? 'None';
      _catBreeds = catBreeds[userDoc.data['prefsCatBreeds']] ?? 'None';
      _dogBreeds = dogBreeds[userDoc.data['prefsDogBreeds']] ?? 'None';
      _otherBreeds = otherBreeds[userDoc.data['prefsOtherBreeds']] ?? 'None';
      _animalSex = animalSexes[userDoc.data['prefsAnimalSex']] ?? 'None';
      goodHumans = userDoc.data['prefsGoodHumans'] ?? null;
      goodAnimals = userDoc.data['prefsGoodAnimals'] ?? null;
      needLeash = userDoc.data['prefsNeedLeash'] ?? null;
      _availability = availability[userDoc.data['prefsAvailability']] ?? 'None';
    });
  }

  void viewPetDetails(BuildContext context, dynamic petDoc, dynamic docId) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PetDetailPage(petDoc: petDoc, userId: widget.userId, docId: docId)));
  }

  bool matchesSearchPrefs(var petDoc) {    
    if (petDoc['animalType'] != _animalType && _animalType != 'None') { return false; }
    else if (petDoc['goodChildren'] != goodHumans && goodHumans != null) { return false; }
    else if (petDoc['goodAnimals'] != goodAnimals && goodAnimals != null) { return false; }
    else if (petDoc['leashNeeded'] != needLeash && needLeash != null) { return false; }
    else if (petDoc['sex'] != _animalSex && _animalSex != 'None') { return false; }
    else if (petDoc['availability'] != _availability && _availability != 'None') { return false; }
    else {
      if (petDoc['animalType'] == 'Cat' && petDoc['breed'] != _catBreeds && _catBreeds != 'None') { return false; }
      else if (petDoc['animalType'] == 'Dog' && petDoc['breed'] != _dogBreeds && _dogBreeds != 'None') { return false; }
      else if (petDoc['animalType'] == 'Other' && petDoc['breed'] != _otherBreeds && _otherBreeds != 'None') { return false; }
      else { return true; }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: StreamBuilder(
          stream: postsRef.snapshots(),
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

            return Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: displayedAnimals.length,
                  itemBuilder: (_, index) {
                    var petDoc = displayedAnimals[index];
                    var docId = displayedAnimals[index].documentID;
                    return Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => viewPetDetails(context, petDoc, docId),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: CachedNetworkImageProvider(
                              petDoc['imageURL'],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                        ),
                        Text(petDoc['name']),
                      ],
                    );
                  }),
            );
          }),
    );
  }
}
