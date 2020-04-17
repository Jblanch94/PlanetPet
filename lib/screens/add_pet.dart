import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as Path;
import '../models/animal.dart';

class PetForm extends StatefulWidget {
  @override
  _PetFormState createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
  final formKey = GlobalKey<FormState>();
  final petFormFields = Animal();

  LocationData locationData;

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    setState(() {});
  }

  File image;
  String imageURL;
  Future<String> getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference storageReference = 
      FirebaseStorage.instance.ref().child(Path.basename(image.path));
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    final url = await storageReference.getDownloadURL();
    setState(() {});
    return url;
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Planet Pet')),
        body: Center(
          child: RaisedButton(
            child: Text('Select Photo'),
            onPressed: () async {
              imageURL = await getImage();
            }
          )
        )
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('Planet Pet')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.file(image, height: 240),
              SizedBox(height: 40),
              Text('Latitude: ${locationData.latitude}'),
              Text('Longitude: ${locationData.longitude}'),
              Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Name of pet', border: OutlineInputBorder()
                        ),
                        onSaved: (value) {
                          petFormFields.name = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a name';
                          } else {
                            return null;
                          }
                        }
                      ),
                      RaisedButton(
                        child: Text('Post it!'),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            Firestore.instance.collection('pets').add({
                              'imageURL': imageURL,
                              'latitude': locationData.latitude,
                              'longitude': locationData.longitude,
                              'name': petFormFields.name,
                            });
                            Navigator.of(context).pop();
                          }
                        })
                    ],
                  )
                )
              )
            ],
          )
        )

      );
    }
  }
}