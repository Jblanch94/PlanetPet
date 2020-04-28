import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:planet_pet/constants.dart';
import 'package:planet_pet/widgets/account_text_field.dart';
import 'package:planet_pet/utils/create_account_validation.dart';

class CreateAccountDetails extends StatefulWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String currentUserName;

  CreateAccountDetails({Key key, this.currentUserName}) : super(key: key);
  @override
  _CreateAccountDetailsState createState() => _CreateAccountDetailsState();
}

class _CreateAccountDetailsState extends State<CreateAccountDetails> {
  AccountFormValidation accountForm = AccountFormValidation();
  LocationData locationData;
  String _selectedState;

  //get user location
  void getUserLocation() async {
    try {
      final location = Location();
      LocationData data = await location.getLocation();
      setState(() {
        locationData = data;
      });
    } catch (err) {
      print('${err.message}');
    }
  }

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        title: Text('Account Details'),
        leading: Text(''),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 32)),
              Form(
                key: widget._formKey,
                child: Column(
                  children: <Widget>[
                    //field for phone number
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: AccountTextField(
                        fieldDecorator: kPhoneFormField,
                        keyboardType: TextInputType.phone,
                        save: accountForm.phoneSave,
                        validate: accountForm.phoneValidate,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),

                      //field for first street address
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: AccountTextField(
                        fieldDecorator: kStreetAddressField1,
                        save: accountForm.streetAddress1Save,
                        validate: accountForm.streetAddress1Validate,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),

                    //field for optional apartment number/second address
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 12),
                      child: AccountTextField(
                        fieldDecorator: kStreetAddressField2,
                        save: accountForm.streetAddress2Save,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),

                    //field for city
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 200),
                      child: AccountTextField(
                        fieldDecorator: kCityField,
                        validate: accountForm.cityValidate,
                        save: accountForm.citySave,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),

                    //dropdown button for state selection
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 80,
                        width: 180,
                        margin: EdgeInsets.only(left: 12),
                        child: DropdownButtonFormField(
                            isDense: true,
                            hint: Text('Select a state'),
                            decoration: InputDecoration(
                              hintText: 'Select a state',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            value: _selectedState,
                            items: accountForm.states
                                .map(
                                  (state) => DropdownMenuItem(
                                    child: Text(state),
                                    value: state,
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedState = value;
                              });
                            },
                            onSaved: (value) {
                              accountForm.user.state = value;
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a state';
                              }
                              return null;
                            }),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),

                    //field for zipcode
                    Container(
                      margin: EdgeInsets.only(left: 12, right: 150),
                      child: AccountTextField(
                        fieldDecorator: kZipcodeField,
                        save: accountForm.zipcodeSave,
                        validate: accountForm.zipcodeValidate,
                        keyboardType: TextInputType.number,
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
                      onPressed: () {
                        if (widget._formKey.currentState.validate()) {
                          widget._formKey.currentState.save();
                          accountForm.user.latitude = locationData.latitude;
                          accountForm.user.longitude = locationData.longitude;
                        
                           Navigator.of(context).pop(accountForm.user);
                        }
                      },
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
