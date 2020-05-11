import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as Path;
import 'package:planet_pet/widgets/custom_scaffold.dart';
import '../models/animal.dart';

//
class PetForm extends StatefulWidget {
  final String userId;
  final bool darkMode;
  final Function(bool) toggleTheme;
  final Function signOut;
  const PetForm(
      {Key key, this.userId, this.darkMode, this.toggleTheme, this.signOut})
      : super(key: key);
  @override
  _PetFormState createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final petFormFields = Animal();
  DocumentSnapshot userDoc;
  CollectionReference usersRef = Firestore.instance.collection('users');

  LocationData locationData;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    retrieveLocation();
    
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    if (this.mounted) {
      setState(() {});
    }
  }

  void getUserDetails() async {
    userDoc = await usersRef.document(widget.userId).get();
    setState(() {});
  }

  File image;
  String imageURL;
  Future<String> getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(Path.basename(image.path));
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    final url = await storageReference.getDownloadURL();
    setState(() {});
    return url;
  }

  DateTime selectedDate = DateTime.now();
  String _sex = "Male";
  String _animalType = "Cat";
  bool _goodAnimals = true;
  bool _goodChildren = true;
  bool _leashNeeded = false;
  String _availability = "Available";

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000, 1),
        lastDate: DateTime.now());
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return CustomScaffold(
        detailsPage: false,
          user: userDoc,
          signOut: widget.signOut,
          scaffoldKey: _scaffoldKey,
          darkMode: widget.darkMode,
          toggleTheme: widget.toggleTheme,
          title: 'Select Photo',
          body: Center(
              child: Semantics(
                  button: true,
                  focused: true,
                  enabled: true,
                  child: RaisedButton(
                      child: Text('Select Photo'),
                      onPressed: () async {
                        imageURL = await getImage();
                      }))));
    } else {
      return CustomScaffold(
        detailsPage: false,
          user: userDoc,
          signOut: widget.signOut,
          scaffoldKey: _scaffoldKey,
          darkMode: widget.darkMode,
          toggleTheme: widget.toggleTheme,
          title: 'Add Pet',
          body: SafeArea(
              child: ListView(
            children: <Widget>[
              Semantics(
                  child: Image.file(image, height: 240), label: "Image of pet"),
              SizedBox(height: 40),
              Text(
                  "FYI: We'll save your current location as this animal's home turf."),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Semantics(
                            child: TextFormField(
                                autofocus: true,
                                decoration: InputDecoration(
                                    labelText: 'Name of pet',
                                    border: OutlineInputBorder()),
                                onSaved: (value) {
                                  petFormFields.name = value;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a name';
                                  } else {
                                    return null;
                                  }
                                }),
                            textField: true,
                            label: "Name of pet",
                            hint: "Give this pet a name",
                          ),
                          SizedBox(height: 10),
                          Text("Birthdate:"),
                          Text("${selectedDate.toLocal()}".split(' ')[0]),
                          Semantics(
                              child: RaisedButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text('Select Birthdate')),
                              label: "Select birthdate",
                              hint: "Select a birthdate for this pet"),
                          SizedBox(height: 10),
                          Text('Sex'),
                          ListTile(
                            dense: true,
                            title: const Text('Male'),
                            leading: Radio(
                                value: "Male",
                                groupValue: _sex,
                                onChanged: (value) {
                                  setState(() {
                                    _sex = value;
                                  });
                                }),
                          ),
                          ListTile(
                              dense: true,
                              title: const Text('Female'),
                              leading: Radio(
                                  value: "Female",
                                  groupValue: _sex,
                                  onChanged: (value) {
                                    setState(() {
                                      _sex = value;
                                    });
                                  })),
                          Text('Animal Type'),
                          ListTile(
                              dense: true,
                              title: const Text('Cat'),
                              leading: Radio(
                                  value: "Cat",
                                  groupValue: _animalType,
                                  onChanged: (value) {
                                    setState(() {
                                      _animalType = value;
                                    });
                                  })),
                          ListTile(
                              dense: true,
                              title: const Text('Dog'),
                              leading: Radio(
                                  value: "Dog",
                                  groupValue: _animalType,
                                  onChanged: (value) {
                                    setState(() {
                                      _animalType = value;
                                    });
                                  })),
                          ListTile(
                              dense: true,
                              title: const Text('Other'),
                              leading: Radio(
                                  value: "Other",
                                  groupValue: _animalType,
                                  onChanged: (value) {
                                    setState(() {
                                      _animalType = value;
                                    });
                                  })),
                          Semantics(
                              child: TextFormField(
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      labelText: 'Breed',
                                      border: OutlineInputBorder()),
                                  onSaved: (value) {
                                    petFormFields.breed = value;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a breed';
                                    } else {
                                      return null;
                                    }
                                  }),
                              textField: true,
                              label: "Breed",
                              hint: "Enter a breed for this pet"),
                          Text('Traits'),
                          ListTile(
                              dense: true,
                              title: const Text('Good with other animals'),
                              leading: Checkbox(
                                  value: _goodAnimals == true,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _goodAnimals = value ? true : false;
                                    });
                                  })),
                          ListTile(
                              dense: true,
                              title: const Text('Good with children'),
                              leading: Checkbox(
                                  value: _goodChildren == true,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _goodChildren = value ? true : false;
                                    });
                                  })),
                          ListTile(
                              dense: true,
                              title: const Text('Leash needed'),
                              leading: Checkbox(
                                  value: _leashNeeded == false,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _leashNeeded = value ? false : true;
                                    });
                                  })),
                          SizedBox(height: 10),
                          Text('Availability'),
                          ListTile(
                              dense: true,
                              title: const Text('Available'),
                              leading: Radio(
                                  value: "Available",
                                  groupValue: _availability,
                                  onChanged: (value) {
                                    setState(() {
                                      _availability = value;
                                    });
                                  })),
                          ListTile(
                              dense: true,
                              title: const Text('Not Available'),
                              leading: Radio(
                                  value: "Not Available",
                                  groupValue: _availability,
                                  onChanged: (value) {
                                    setState(() {
                                      _availability = value;
                                    });
                                  })),
                          ListTile(
                              dense: true,
                              title: const Text('Pending'),
                              leading: Radio(
                                  value: "Pending",
                                  groupValue: _availability,
                                  onChanged: (value) {
                                    setState(() {
                                      _availability = value;
                                    });
                                  })),
                          ListTile(
                              dense: true,
                              title: const Text('Adopted'),
                              leading: Radio(
                                  value: "Adopted",
                                  groupValue: _availability,
                                  onChanged: (value) {
                                    setState(() {
                                      _availability = value;
                                    });
                                  })),
                          Semantics(
                              child: TextFormField(
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      labelText: 'Status',
                                      border: OutlineInputBorder()),
                                  onSaved: (value) {
                                    petFormFields.status = value;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a status';
                                    } else {
                                      return null;
                                    }
                                  }),
                              textField: true,
                              label: "Enter status",
                              hint: "Enter a status for this pet"),
                          SizedBox(height: 10),
                          Semantics(
                              child: TextFormField(
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      labelText: 'Description',
                                      border: OutlineInputBorder()),
                                  onSaved: (value) {
                                    petFormFields.description = value;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a description';
                                    } else {
                                      return null;
                                    }
                                  }),
                              textField: true,
                              label: "Description",
                              hint: "Enter a description for this pet"),
                          Semantics(
                              child: RaisedButton(
                                  child: Text('Post it!'),
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();
                                      Firestore.instance
                                          .collection('pets')
                                          .add({
                                        'imageURL': imageURL,
                                        'latitude': locationData.latitude,
                                        'longitude': locationData.longitude,
                                        'name': petFormFields.name,
                                        'dateOfBirth': selectedDate.toLocal(),
                                        'sex': _sex,
                                        'animalType': _animalType,
                                        'breed': petFormFields.breed,
                                        'goodAnimals':
                                            petFormFields.goodAnimals,
                                        'goodChildren':
                                            petFormFields.goodChildren,
                                        'leashNeeded':
                                            petFormFields.leashNeeded,
                                        'availability': _availability,
                                        'status': petFormFields.status,
                                        'description':
                                            petFormFields.description,
                                      });
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Congrats! You added ${petFormFields.name} as a pet!'),
                                      ));

                                      image = null;
                                      formKey.currentState.reset();
                                      setState(
                                          () {}); // Navigator.of(context).pop();
                                    }
                                  }),
                              button: true,
                              label: "Submit pet to database",
                              hint: "Submit pet to database")
                        ],
                      )))
            ],
          )));
    }
  }
}
