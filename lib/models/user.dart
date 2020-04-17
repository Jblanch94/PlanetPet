import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String email;
  bool isAdmin;
  String phoneNumber;
  double latitude;
  double longitude;
  String streetAddress;
  String city;
  String state;
  String zipcode;

  var adoptedAnimals = [];
  var favoritedAnimals = [];

  User(
      {this.username,
      this.email,
      this.isAdmin,
      this.phoneNumber,
      this.latitude,
      this.longitude,
      this.streetAddress,
      this.city,
      this.state,
      this.zipcode});

  factory User.fromDocument(DocumentSnapshot record) {
    return User(
        username: record['username'],
        email: record['email'],
        isAdmin: record['isAdmin'],
        phoneNumber: record['phoneNumber'],
        latitude: record['latitude'],
        longitude: record['longitude'],
        streetAddress: record['streetAddress'],
        city: record['city'],
        state: record['state'],
        zipcode: record['zipcode']);
  }
}
