import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planet_pet/widgets/custom_scaffold.dart';
import 'package:planet_pet/widgets/drawer.dart';

enum AnimalType { none, cat, dog, other }
enum CatBreeds { none, persian, shorthair, himalayan }
enum DogBreeds { none, goldenRetriever, germanShepherd, beagle, poodle }
enum OtherBreeds { none, bird, frog, lizard, snake }
enum AnimalSex { none, male, female }
enum Availability { none, available, pending, adopted }

class Preferences extends StatefulWidget {
  final String userId;
  final bool darkMode;
  final Function(bool) toggleTheme;
  const Preferences({Key key, this.userId, this.darkMode, this.toggleTheme})
      : super(key: key);

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
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
    return CustomScaffold(
      scaffoldKey: _scaffoldKey,
      darkMode: widget.darkMode,
      toggleTheme: widget.toggleTheme,
      title: 'Preferences',
      body: preferencesBody(context),
    );
  }

  Widget preferencesBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          resetPrefs(context),
          Divider(height: 0),
          animalType(context),
          Divider(height: 20),
          animalBreed(context),
          Divider(height: 20),
          animalSex(context),
          Divider(height: 20),
          animalBehavior(context),
          Divider(height: 20),
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
        child: ListTile(
          title: Text('Reset Search Preferences',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.red,
            )
          )
        )
    );
  }

  Widget animalType(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(bottom: 10)),
        Text('Type',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _animalType = AnimalType.none;
                    usersRef.document(widget.userId).setData({
                      'prefsAnimalType': 0,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: AnimalType.none,
                      groupValue: _animalType,
                      onChanged: (AnimalType value) {
                        setState(() {
                          _animalType = value;
                          usersRef.document(widget.userId).setData({
                            'prefsAnimalType': 0,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('All', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _animalType = AnimalType.cat;
                    usersRef.document(widget.userId).setData({
                      'prefsAnimalType': 1,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: AnimalType.cat,
                      groupValue: _animalType,
                      onChanged: (AnimalType value) {
                        setState(() {
                          _animalType = value;
                          usersRef.document(widget.userId).setData({
                            'prefsAnimalType': 1,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Cat', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _animalType = AnimalType.dog;
                    usersRef.document(widget.userId).setData({
                      'prefsAnimalType': 2,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: AnimalType.dog,
                      groupValue: _animalType,
                      onChanged: (AnimalType value) {
                        setState(() {
                          _animalType = value;
                          usersRef.document(widget.userId).setData({
                            'prefsAnimalType': 2,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Dog', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _animalType = AnimalType.other;
                    usersRef.document(widget.userId).setData({
                      'prefsAnimalType': 3,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: AnimalType.other,
                      groupValue: _animalType,
                      onChanged: (AnimalType value) {
                        setState(() {
                          _animalType = value;
                          usersRef.document(widget.userId).setData({
                            'prefsAnimalType': 3,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Other', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
          ],
        )
      ]
    );
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
            ListTile(title: Text('Please select a specific Animal Type')),
          ]);
    }
  }

  Widget catBreeds(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        breed(),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _catBreeds = CatBreeds.none;
                    usersRef.document(widget.userId).setData({
                      'prefsCatBreeds': 0,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: CatBreeds.none,
                      groupValue: _catBreeds,
                      onChanged: (CatBreeds value) {
                        setState(() {
                          _catBreeds = CatBreeds.none;
                          usersRef.document(widget.userId).setData({
                            'prefsCatBreeds': 0,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('All', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _catBreeds = CatBreeds.persian;
                    usersRef.document(widget.userId).setData({
                      'prefsCatBreeds': 1,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: CatBreeds.persian,
                      groupValue: _catBreeds,
                      onChanged: (CatBreeds value) {
                        setState(() {
                          _catBreeds = CatBreeds.persian;
                          usersRef.document(widget.userId).setData({
                            'prefsCatBreeds': 1,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Persian', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _catBreeds = CatBreeds.shorthair;
                    usersRef.document(widget.userId).setData({
                      'prefsCatBreeds': 2,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: CatBreeds.shorthair,
                      groupValue: _catBreeds,
                      onChanged: (CatBreeds value) {
                        setState(() {
                          _catBreeds = CatBreeds.shorthair;
                          usersRef.document(widget.userId).setData({
                            'prefsCatBreeds': 2,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Short Hair', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _catBreeds = CatBreeds.himalayan;
                    usersRef.document(widget.userId).setData({
                      'prefsCatBreeds': 3,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: CatBreeds.himalayan,
                      groupValue: _catBreeds,
                      onChanged: (CatBreeds value) {
                        setState(() {
                          _catBreeds = CatBreeds.himalayan;
                          usersRef.document(widget.userId).setData({
                            'prefsCatBreeds': 3,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Himalayan', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
          ],
        ),
      ],
    );
  }

  Widget dogBreeds(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        breed(),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _dogBreeds = DogBreeds.none;
                    usersRef.document(widget.userId).setData({
                      'prefsDogBreeds': 0,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: DogBreeds.none,
                      groupValue: _dogBreeds,
                      onChanged: (DogBreeds value) {
                        setState(() {
                          _dogBreeds = DogBreeds.none;
                          usersRef.document(widget.userId).setData({
                            'prefsDogBreeds': 0,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('All', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 19),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _dogBreeds = DogBreeds.goldenRetriever;
                    usersRef.document(widget.userId).setData({
                      'prefsDogBreeds': 1,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: DogBreeds.goldenRetriever,
                      groupValue: _dogBreeds,
                      onChanged: (DogBreeds value) {
                        setState(() {
                          _dogBreeds = DogBreeds.goldenRetriever;
                          usersRef.document(widget.userId).setData({
                            'prefsDogBreeds': 1,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Golden Retriever', 
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)
                    ),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _dogBreeds = DogBreeds.germanShepherd;
                    usersRef.document(widget.userId).setData({
                      'prefsDogBreeds': 2,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: DogBreeds.germanShepherd,
                      groupValue: _dogBreeds,
                      onChanged: (DogBreeds value) {
                        setState(() {
                          _dogBreeds = DogBreeds.germanShepherd;
                          usersRef.document(widget.userId).setData({
                            'prefsDogBreeds': 2,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('German Shepherd', 
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)
                    ),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _dogBreeds = DogBreeds.beagle;
                    usersRef.document(widget.userId).setData({
                      'prefsDogBreeds': 3,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: DogBreeds.beagle,
                      groupValue: _dogBreeds,
                      onChanged: (DogBreeds value) {
                        setState(() {
                          _dogBreeds = DogBreeds.beagle;
                          usersRef.document(widget.userId).setData({
                            'prefsDogBreeds': 3,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Beagle', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 19),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _dogBreeds = DogBreeds.poodle;
                    usersRef.document(widget.userId).setData({
                      'prefsDogBreeds': 4,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: DogBreeds.poodle,
                      groupValue: _dogBreeds,
                      onChanged: (DogBreeds value) {
                        setState(() {
                          _dogBreeds = DogBreeds.poodle;
                          usersRef.document(widget.userId).setData({
                            'prefsDogBreeds': 4,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Poodle', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 19),
                  ],
                )
              )
            ),
          ],
        ),
      ],
    );
  }

  Widget otherBreeds(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        breed(),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _otherBreeds = OtherBreeds.none;
                    usersRef.document(widget.userId).setData({
                      'prefsOtherBreeds': 0,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: OtherBreeds.none,
                      groupValue: _otherBreeds,
                      onChanged: (OtherBreeds value) {
                        setState(() {
                          _otherBreeds = OtherBreeds.none;
                          usersRef.document(widget.userId).setData({
                            'prefsOtherBreeds': 0,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('All', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _otherBreeds = OtherBreeds.bird;
                    usersRef.document(widget.userId).setData({
                      'prefsOtherBreeds': 1,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: OtherBreeds.bird,
                      groupValue: _otherBreeds,
                      onChanged: (OtherBreeds value) {
                        setState(() {
                          _otherBreeds = OtherBreeds.bird;
                          usersRef.document(widget.userId).setData({
                            'prefsOtherBreeds': 1,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Bird', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _otherBreeds = OtherBreeds.frog;
                    usersRef.document(widget.userId).setData({
                      'prefsOtherBreeds': 2,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: OtherBreeds.frog,
                      groupValue: _otherBreeds,
                      onChanged: (OtherBreeds value) {
                        setState(() {
                          _otherBreeds = OtherBreeds.frog;
                          usersRef.document(widget.userId).setData({
                            'prefsOtherBreeds': 2,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Frog', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _otherBreeds = OtherBreeds.lizard;
                    usersRef.document(widget.userId).setData({
                      'prefsOtherBreeds': 3,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: OtherBreeds.lizard,
                      groupValue: _otherBreeds,
                      onChanged: (OtherBreeds value) {
                        setState(() {
                          _otherBreeds = OtherBreeds.lizard;
                          usersRef.document(widget.userId).setData({
                            'prefsOtherBreeds': 3,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Lizard', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _otherBreeds = OtherBreeds.snake;
                    usersRef.document(widget.userId).setData({
                      'prefsOtherBreeds': 3,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: OtherBreeds.snake,
                      groupValue: _otherBreeds,
                      onChanged: (OtherBreeds value) {
                        setState(() {
                          _otherBreeds = OtherBreeds.snake;
                          usersRef.document(widget.userId).setData({
                            'prefsOtherBreeds': 4,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Snake', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
          ],
        ),
      ],
    );
  }

  Widget animalSex(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Sex',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _animalSex = AnimalSex.none;
                    usersRef.document(widget.userId).setData({
                      'prefsAnimalSex': 0,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: AnimalSex.none,
                      groupValue: _animalSex,
                      onChanged: (AnimalSex value) {
                        setState(() {
                          _animalSex = AnimalSex.none;
                          usersRef.document(widget.userId).setData({
                            'prefsAnimalSex': 0,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('All', style: TextStyle(fontSize: 16)),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _animalSex = AnimalSex.male;
                    usersRef.document(widget.userId).setData({
                      'prefsAnimalSex': 1,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: AnimalSex.male,
                      groupValue: _animalSex,
                      onChanged: (AnimalSex value) {
                        setState(() {
                          _animalSex = AnimalSex.male;
                          usersRef.document(widget.userId).setData({
                            'prefsAnimalSex': 1,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Male', 
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)
                    ),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _animalSex = AnimalSex.female;
                    usersRef.document(widget.userId).setData({
                      'prefsAnimalSex': 2,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: AnimalSex.female,
                      groupValue: _animalSex,
                      onChanged: (AnimalSex value) {
                        setState(() {
                          _animalSex = AnimalSex.female;
                          usersRef.document(widget.userId).setData({
                            'prefsAnimalSex': 2,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Female', 
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)
                    ),
                  ],
                )
              )
            ),
          ],
        ),
      ],
    );
  }

  Widget animalBehavior(BuildContext context) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('Behavior Traits',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  goodHumans = !goodHumans;
                  usersRef.document(widget.userId).setData({
                    'prefsGoodHumans': goodHumans,
                  }, merge: true);
                });
              },
              child: Column(
                children: <Widget>[
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
                  Text('Good With Children', 
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  goodAnimals = !goodAnimals;
                  usersRef.document(widget.userId).setData({
                    'prefsGoodAnimals': goodAnimals,
                  }, merge: true);
                });
              },
              child: Column(
                children: <Widget>[
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
                  Text('Good With Animals', 
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  needLeash = !needLeash;
                  usersRef.document(widget.userId).setData({
                    'prefsNeedLeash': needLeash,
                  }, merge: true);
                });
              },
              child: Column(
                children: <Widget>[
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
                  Text('Needs A Leash', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      )
    ]);
  }

  Widget animalAvailability(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Availability',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _availability = Availability.none;
                    usersRef.document(widget.userId).setData({
                      'prefsAvailability': 0,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: Availability.none,
                      groupValue: _availability,
                      onChanged: (Availability value) {
                        setState(() {
                          _availability = Availability.none;
                          usersRef.document(widget.userId).setData({
                            'prefsAvailability': 0,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('All', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 19),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _availability = Availability.available;
                    usersRef.document(widget.userId).setData({
                      'prefsAvailability': 1,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: Availability.available,
                      groupValue: _availability,
                      onChanged: (Availability value) {
                        setState(() {
                          _availability = Availability.available;
                          usersRef.document(widget.userId).setData({
                            'prefsAvailability': 1,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Available', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 19),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _availability = Availability.pending;
                    usersRef.document(widget.userId).setData({
                      'prefsAvailability': 2,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: Availability.pending,
                      groupValue: _availability,
                      onChanged: (Availability value) {
                        setState(() {
                          _availability = Availability.pending;
                          usersRef.document(widget.userId).setData({
                            'prefsAvailability': 2,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Pending Adoption', 
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)
                    ),
                  ],
                )
              )
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _availability = Availability.adopted;
                    usersRef.document(widget.userId).setData({
                      'prefsAvailability': 3,
                    }, merge: true);
                  });
                },
                child: Column(
                  children: <Widget>[
                    Radio(
                      value: Availability.adopted,
                      groupValue: _availability,
                      onChanged: (Availability value) {
                        setState(() {
                          _availability = Availability.adopted;
                          usersRef.document(widget.userId).setData({
                            'prefsAvailability': 3,
                          }, merge: true);
                        });
                      }
                    ),
                    Text('Adopted', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 19),
                  ],
                )
              )
            ),
          ],
        ),
      ],
    );
  }
}
