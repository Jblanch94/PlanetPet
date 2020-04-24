import 'package:flutter/material.dart';
import 'package:planet_pet/models/user.dart';

class CreateAccountDetails extends StatefulWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  _CreateAccountDetailsState createState() => _CreateAccountDetailsState();
}

//TODO: ADD VALIDATION AND ONCHANGED FUNCTIONALITY
//TODO: ADD DROPDOWNBUTTON FOR STATES
class _CreateAccountDetailsState extends State<CreateAccountDetails> {
  User user = User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 32)),
              Form(
                key: widget._formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        autovalidate: true,
                        validator: (value) {
                          if (value.trim().length != 10) {
                            return 'Invalid phone Number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter your phone number...',
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Street Address 1',
                          hintText: 'Street Address 1',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Street Address 2/Apartment',
                          hintText: 'Street Address 2/Apartment',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 200),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'City',
                          hintText: 'Enter your city...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 150),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Zipcode',
                          hintText: 'Enter your zipcode...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    RaisedButton(
                      elevation: 11,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      onPressed: () => print('submitted'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
