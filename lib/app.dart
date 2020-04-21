import 'package:flutter/material.dart';
import 'package:planet_pet/screens/home.dart';
import 'package:planet_pet/screens/add_pet.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PetForm(),
    );
  }
}