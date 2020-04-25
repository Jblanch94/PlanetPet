import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String userId;
  String email;
  bool isAdmin;
  String phoneNumber;
  double latitude;
  double longitude;
  String streetAddress1;
  String streetAddress2;
  String city;
  String state;
  String zipcode;

  var adoptedAnimals = [];
  var favoritedAnimals = [];

  User(
      {this.username,
      this.userId,
      this.email,
      this.isAdmin,
      this.phoneNumber,
      this.latitude,
      this.longitude,
      this.streetAddress1,
      this.streetAddress2,
      this.city,
      this.state,
      this.zipcode});

  factory User.fromDocument(DocumentSnapshot record) {
    return User(
        username: record['username'],
        userId: record['userId'],
        email: record['email'],
        isAdmin: record['isAdmin'],
        phoneNumber: record['phoneNumber'],
        latitude: record['latitude'],
        longitude: record['longitude'],
        streetAddress1: record['streetAddress1'],
        streetAddress2: record['streetAddress2'],
        city: record['city'],
        state: record['state'],
        zipcode: record['zipcode']);
  }
}
