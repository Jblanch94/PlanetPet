import 'package:flutter/material.dart';

class PetDetailPage extends StatelessWidget {

  final dynamic petDoc;

  PetDetailPage({Key key, this.petDoc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(petDoc['name']);
  }
}