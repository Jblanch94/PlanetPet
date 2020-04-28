import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PetDetailPage extends StatefulWidget {
  final dynamic petDoc;

  PetDetailPage({Key key, this.petDoc}) : super(key: key);

  @override
  _PetDetailPageState createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  bool favorited = false;

  void favoritePet() {
    setState(() {
      favorited = !favorited;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Details'),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.petDoc['imageURL']),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text("Name: ${widget.petDoc['name']}"),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text("Birthdate: ${widget.petDoc['dateOfBirth']}"),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text("Sex: ${widget.petDoc['sex']}"),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text("Animal type: ${widget.petDoc['animalType']}"),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text("Breed: ${widget.petDoc['breed']}"),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              widget.petDoc['goodAnimals']
                  ? Text('${widget.petDoc['name']} is good with other animals.')
                  : Text(
                      '${widget.petDoc['name']} is not good with other animals.'),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              widget.petDoc['goodChildren']
                  ? Text('${widget.petDoc['name']} is good with children.')
                  : Text('${widget.petDoc['name']} is not good with children.'),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              widget.petDoc['leashNeeded']
                  ? Text('Leash required')
                  : Text('Leash not required'),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text('Availability: ${widget.petDoc['availability']}'),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text('Status: ${widget.petDoc['status']}'),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Text(
                'Description: ${widget.petDoc['description']}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon:
                        favorited ? Icon(Icons.star, color: Colors.yellow) : Icon(Icons.star_border),
                    iconSize: 30,
                    color: Colors.yellow[700],
                    onPressed: favoritePet,
                  ),
                  IconButton(
                    color: Colors.lightGreen,
                    icon: Icon(Icons.check_circle),
                    onPressed: () => print('Adopted'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
