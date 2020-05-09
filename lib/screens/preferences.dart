import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planet_pet/widgets/drawer.dart';

enum AnimalType { none, cat, dog, other }
enum CatBreeds { none, persian, shorthair, himalayan }
enum DogBreeds { none, goldenRetriever, germanShepherd, beagle, poodle }
enum OtherBreeds { none, bird, frog, lizard, snake }
enum AnimalSex { none, male, female }
enum Availability { none, available, pending, adopted }

class Preferences extends StatefulWidget {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final String userId;
  final bool darkMode;
  final Function(bool) toggleTheme;
  Preferences({Key key, this.userId, this.darkMode, this.toggleTheme})
      : super(key: key);

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  final CollectionReference usersRef = Firestore.instance.collection('users');

  AnimalType _animalType;
  CatBreeds _catBreeds;
  DogBreeds _dogBreeds;
  OtherBreeds _otherBreeds;
  AnimalSex _animalSex;
  bool goodHumans = true;
  bool goodAnimals = true;
  bool needLeash = true;
  Availability _availability;

  void initState() {
    super.initState();
    initSearchPreferences();
  }

  void initSearchPreferences() async {
    DocumentSnapshot userDoc = await usersRef.document(widget.userId).get();

    setState(() {
      _animalType =
          AnimalType.values[userDoc.data['prefsAnimalType']] ?? AnimalType.none;
      _catBreeds =
          CatBreeds.values[userDoc.data['prefsCatBreeds']] ?? CatBreeds.none;
      _dogBreeds =
          DogBreeds.values[userDoc.data['prefsDogBreeds']] ?? DogBreeds.none;
      _otherBreeds = OtherBreeds.values[userDoc.data['prefsOtherBreeds']] ??
          OtherBreeds.none;
      _animalSex =
          AnimalSex.values[userDoc.data['prefsAnimalSex']] ?? AnimalSex.none;
      goodHumans = userDoc.data['prefsGoodHumans'] ?? true;
      goodAnimals = userDoc.data['prefsGoodAnimals'] ?? true;
      needLeash = userDoc.data['prefsNeedLeash'] ?? true;
      _availability = Availability.values[userDoc.data['prefsAvailability']] ??
          Availability.none;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      endDrawer: SettingsDrawer(
          darkMode: widget.darkMode, toggleTheme: widget.toggleTheme),
      appBar: AppBar(
        title: Text('Preferences'),
        centerTitle: true,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: preferencesBody(context),
    );
  }

  Widget preferencesBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          resetPrefs(context),
          Divider(height: 30),
          animalType(context),
          Divider(height: 30),
          animalBreed(context),
          Divider(height: 30),
          animalSex(context),
          Divider(height: 30),
          animalBehavior(context),
          Divider(height: 30),
          animalAvailability(context),
        ],
      ),
    );
  }

  Widget resetPrefs(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            _animalType = AnimalType.none;
            _catBreeds = CatBreeds.none;
            _dogBreeds = DogBreeds.none;
            _otherBreeds = OtherBreeds.none;
            _animalSex = AnimalSex.none;
            goodHumans = true;
            goodAnimals = true;
            needLeash = true;
            _availability = Availability.none;
            usersRef.document(widget.userId).setData({
              'prefsAnimalType': 0,
              'prefsCatBreeds': 0,
              'prefsDogBreeds': 0,
              'prefsOtherBreeds': 0,
              'prefsAnimalSex': 0,
              'prefsGoodHumans': true,
              'prefsGoodAnimals': true,
              'prefsNeedLeash': true,
              'prefsAvailability': 0,
            }, merge: true);
          });
        },
        child: Text('Reset Search Preferences',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.red,
            )));
  }

  Widget animalType(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Type',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ListTile(
            title: Text('All'),
            leading: Radio(
              value: AnimalType.none,
              groupValue: _animalType,
              onChanged: (AnimalType value) {
                setState(() {
                  _animalType = value;
                  usersRef.document(widget.userId).setData({
                    'prefsAnimalType': 0,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Cat'),
            leading: Radio(
              value: AnimalType.cat,
              groupValue: _animalType,
              onChanged: (AnimalType value) {
                setState(() {
                  _animalType = value;
                  usersRef.document(widget.userId).setData({
                    'prefsAnimalType': 1,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Dog'),
            leading: Radio(
              value: AnimalType.dog,
              groupValue: _animalType,
              onChanged: (AnimalType value) {
                setState(() {
                  _animalType = value;
                  usersRef.document(widget.userId).setData({
                    'prefsAnimalType': 2,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Other'),
            leading: Radio(
              value: AnimalType.other,
              groupValue: _animalType,
              onChanged: (AnimalType value) {
                setState(() {
                  _animalType = value;
                  usersRef.document(widget.userId).setData({
                    'prefsAnimalType': 3,
                  }, merge: true);
                });
              },
            ),
          ),
        ]);
  }

  Widget breed() {
    return Text('Breed',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }

  Widget animalBreed(BuildContext context) {
    if (_animalType == AnimalType.cat) {
      return catBreeds(context);
    } else if (_animalType == AnimalType.dog) {
      return dogBreeds(context);
    } else if (_animalType == AnimalType.other) {
      return otherBreeds(context);
    } else {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            breed(),
            ListTile(title: Text('Please select an Animal Type')),
          ]);
    }
  }

  Widget catBreeds(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          breed(),
          ListTile(
            title: Text('All'),
            leading: Radio(
              value: CatBreeds.none,
              groupValue: _catBreeds,
              onChanged: (CatBreeds value) {
                setState(() {
                  _catBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsCatBreeds': 0,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Persian'),
            leading: Radio(
              value: CatBreeds.persian,
              groupValue: _catBreeds,
              onChanged: (CatBreeds value) {
                setState(() {
                  _catBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsCatBreeds': 1,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Short Hair'),
            leading: Radio(
              value: CatBreeds.shorthair,
              groupValue: _catBreeds,
              onChanged: (CatBreeds value) {
                setState(() {
                  _catBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsCatBreeds': 2,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Himalayan'),
            leading: Radio(
              value: CatBreeds.himalayan,
              groupValue: _catBreeds,
              onChanged: (CatBreeds value) {
                setState(() {
                  _catBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsCatBreeds': 3,
                  }, merge: true);
                });
              },
            ),
          ),
        ]);
  }

  Widget dogBreeds(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          breed(),
          ListTile(
            title: Text('All'),
            leading: Radio(
              value: DogBreeds.none,
              groupValue: _dogBreeds,
              onChanged: (DogBreeds value) {
                setState(() {
                  _dogBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsDogBreeds': 0,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Golden Retriever'),
            leading: Radio(
              value: DogBreeds.goldenRetriever,
              groupValue: _dogBreeds,
              onChanged: (DogBreeds value) {
                setState(() {
                  _dogBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsDogBreeds': 1,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('German Shepherd'),
            leading: Radio(
              value: DogBreeds.germanShepherd,
              groupValue: _dogBreeds,
              onChanged: (DogBreeds value) {
                setState(() {
                  _dogBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsDogBreeds': 2,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Beagle'),
            leading: Radio(
              value: DogBreeds.beagle,
              groupValue: _dogBreeds,
              onChanged: (DogBreeds value) {
                setState(() {
                  _dogBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsDogBreeds': 3,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Poodle'),
            leading: Radio(
              value: DogBreeds.poodle,
              groupValue: _dogBreeds,
              onChanged: (DogBreeds value) {
                setState(() {
                  _dogBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsDogBreeds': 4,
                  }, merge: true);
                });
              },
            ),
          ),
        ]);
  }

  Widget otherBreeds(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          breed(),
          ListTile(
            title: Text('All'),
            leading: Radio(
              value: OtherBreeds.none,
              groupValue: _otherBreeds,
              onChanged: (OtherBreeds value) {
                setState(() {
                  _otherBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsOtherBreeds': 0,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Bird'),
            leading: Radio(
              value: OtherBreeds.bird,
              groupValue: _otherBreeds,
              onChanged: (OtherBreeds value) {
                setState(() {
                  _otherBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsOtherBreeds': 1,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Frog'),
            leading: Radio(
              value: OtherBreeds.frog,
              groupValue: _otherBreeds,
              onChanged: (OtherBreeds value) {
                setState(() {
                  _otherBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsOtherBreeds': 2,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Lizard'),
            leading: Radio(
              value: OtherBreeds.lizard,
              groupValue: _otherBreeds,
              onChanged: (OtherBreeds value) {
                setState(() {
                  _otherBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsOtherBreeds': 3,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Snake'),
            leading: Radio(
              value: OtherBreeds.snake,
              groupValue: _otherBreeds,
              onChanged: (OtherBreeds value) {
                setState(() {
                  _otherBreeds = value;
                  usersRef.document(widget.userId).setData({
                    'prefsOtherBreeds': 4,
                  }, merge: true);
                });
              },
            ),
          ),
        ]);
  }

  Widget animalSex(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Sex',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ListTile(
            title: Text('All'),
            leading: Radio(
              value: AnimalSex.none,
              groupValue: _animalSex,
              onChanged: (AnimalSex value) {
                setState(() {
                  _animalSex = value;
                  usersRef.document(widget.userId).setData({
                    'prefsAnimalSex': 0,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Male'),
            leading: Radio(
              value: AnimalSex.male,
              groupValue: _animalSex,
              onChanged: (AnimalSex value) {
                setState(() {
                  _animalSex = value;
                  usersRef.document(widget.userId).setData({
                    'prefsAnimalSex': 1,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Female'),
            leading: Radio(
              value: AnimalSex.female,
              groupValue: _animalSex,
              onChanged: (AnimalSex value) {
                setState(() {
                  _animalSex = value;
                  usersRef.document(widget.userId).setData({
                    'prefsAnimalSex': 2,
                  }, merge: true);
                });
              },
            ),
          ),
        ]);
  }

  Widget animalBehavior(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Behavior Traits',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          InkWell(
            onTap: () {
              setState(() {
                goodHumans = !goodHumans;
                usersRef.document(widget.userId).setData({
                  'prefsGoodHumans': goodHumans,
                }, merge: true);
              });
            },
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 15)),
                Checkbox(
                    value: goodHumans,
                    onChanged: (bool newValue) {
                      setState(() {
                        goodHumans = !goodHumans;
                        usersRef.document(widget.userId).setData({
                          'prefsGoodHumans': goodHumans,
                        }, merge: true);
                      });
                    }),
                Padding(padding: EdgeInsets.only(left: 18)),
                Expanded(child: Text('Good With Children')),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                goodAnimals = !goodAnimals;
                usersRef.document(widget.userId).setData({
                  'prefsGoodAnimals': goodAnimals,
                }, merge: true);
              });
            },
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 15)),
                Checkbox(
                    value: goodAnimals,
                    onChanged: (bool newValue) {
                      setState(() {
                        goodAnimals = !goodAnimals;
                        usersRef.document(widget.userId).setData({
                          'prefsGoodAnimals': goodAnimals,
                        }, merge: true);
                      });
                    }),
                Padding(padding: EdgeInsets.only(left: 18)),
                Expanded(child: Text('Good With Animals')),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                needLeash = !needLeash;
                usersRef.document(widget.userId).setData({
                  'prefsNeedLeash': needLeash,
                }, merge: true);
              });
            },
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 15)),
                Checkbox(
                    value: needLeash,
                    onChanged: (bool newValue) {
                      setState(() {
                        needLeash = !needLeash;
                        usersRef.document(widget.userId).setData({
                          'prefsNeedLeash': needLeash,
                        }, merge: true);
                      });
                    }),
                Padding(padding: EdgeInsets.only(left: 18)),
                Expanded(child: Text('Needs A Leash')),
              ],
            ),
          ),
        ]);
  }

  Widget animalAvailability(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Availability',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ListTile(
            title: Text('All'),
            leading: Radio(
              value: Availability.none,
              groupValue: _availability,
              onChanged: (Availability value) {
                setState(() {
                  _availability = value;
                  usersRef.document(widget.userId).setData({
                    'prefsAvailability': 0,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Available'),
            leading: Radio(
              value: Availability.available,
              groupValue: _availability,
              onChanged: (Availability value) {
                setState(() {
                  _availability = value;
                  usersRef.document(widget.userId).setData({
                    'prefsAvailability': 1,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Pending Adoption'),
            leading: Radio(
              value: Availability.pending,
              groupValue: _availability,
              onChanged: (Availability value) {
                setState(() {
                  _availability = value;
                  usersRef.document(widget.userId).setData({
                    'prefsAvailability': 2,
                  }, merge: true);
                });
              },
            ),
          ),
          ListTile(
            title: Text('Adopted'),
            leading: Radio(
              value: Availability.adopted,
              groupValue: _availability,
              onChanged: (Availability value) {
                setState(() {
                  _availability = value;
                  usersRef.document(widget.userId).setData({
                    'prefsAvailability': 3,
                  }, merge: true);
                });
              },
            ),
          ),
        ]);
  }
}
