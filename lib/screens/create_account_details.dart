import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
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
                    Semantics(
                        child: Container(
                          //margin: EdgeInsets.only(left: 12, right: 12),
                          margin: orientation == Orientation.portrait
                              ? EdgeInsets.only(
                                  left: height * 0.02, right: height * 0.03)
                              : EdgeInsets.only(
                                  left: width * 0.02, right: width * 0.1),
                          child: AccountTextField(
                            fieldDecorator: kPhoneFormField,
                            keyboardType: TextInputType.phone,
                            save: accountForm.phoneSave,
                            validate: accountForm.phoneValidate,
                          ),
                        ),
                        textField: true,
                        label: "Enter phone number",
                        hint: "Enter your phone number"),
                    Padding(
                      padding: orientation == Orientation.portrait
                          ? EdgeInsets.only(top: height * 0.035)
                          : EdgeInsets.only(top: width * 0.04),

                      //field for first street address
                    ),
                    Semantics(
                        child: Container(
                          margin: orientation == Orientation.portrait
                              ? EdgeInsets.only(
                                  left: height * 0.02, right: height * 0.03)
                              : EdgeInsets.only(
                                  left: width * 0.02, right: width * 0.1),
                          child: AccountTextField(
                            fieldDecorator: kStreetAddressField1,
                            save: accountForm.streetAddress1Save,
                            validate: accountForm.streetAddress1Validate,
                          ),
                        ),
                        textField: true,
                        label: "Street Address Field 1",
                        hint: "Enter your street address"),
                    Padding(
                      padding: orientation == Orientation.portrait
                          ? EdgeInsets.only(top: height * 0.035)
                          : EdgeInsets.only(top: width * 0.04),
                    ),

                    //field for optional apartment number/second address
                    Semantics(
                        child: Container(
                          margin: orientation == Orientation.portrait
                              ? EdgeInsets.only(
                                  left: height * 0.02, right: height * 0.03)
                              : EdgeInsets.only(
                                  left: width * 0.02, right: width * 0.1),
                          child: AccountTextField(
                            fieldDecorator: kStreetAddressField2,
                            save: accountForm.streetAddress2Save,
                          ),
                        ),
                        textField: true,
                        label: "Street Address Field 2",
                        hint: "Enter your street address"),
                    Padding(
                      padding: orientation == Orientation.portrait
                          ? EdgeInsets.only(top: height * 0.035)
                          : EdgeInsets.only(top: width * 0.04),
                    ),

                    //field for city
                    Semantics(
                        child: Container(
                          //margin: EdgeInsets.only(left: 12, right: 200),
                          margin: orientation == Orientation.portrait
                              ? EdgeInsets.only(
                                  left: height * 0.02, right: height * 0.2)
                              : EdgeInsets.only(
                                  left: width * 0.02, right: width * 0.55),
                          child: AccountTextField(
                            fieldDecorator: kCityField,
                            validate: accountForm.cityValidate,
                            save: accountForm.citySave,
                          ),
                        ),
                        textField: true,
                        label: "City",
                        hint: "Enter your city"),
                    Padding(
                      padding: orientation == Orientation.portrait
                          ? EdgeInsets.only(top: height * 0.035)
                          : EdgeInsets.only(top: width * 0.04),
                    ),

                    //dropdown button for state selection
                    Semantics(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            //height: 80,
                            //width: 180,
                            height: orientation == Orientation.portrait
                                ? height * 0.1
                                : width * 0.1,
                            width: orientation == Orientation.portrait
                                ? height * 0.25
                                : width * 0.25,
                            margin: orientation == Orientation.portrait
                                ? EdgeInsets.only(left: height * 0.02)
                                : EdgeInsets.only(left: width * 0.02),
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
                        label: "State selection dropdown",
                        hint: "Select your state"),

                    Padding(
                      padding: orientation == Orientation.portrait
                          ? EdgeInsets.only(top: height * 0.035)
                          : EdgeInsets.only(top: width * 0.04),
                    ),

                    //field for zipcode
                    Semantics(
                        child: Container(
                          //margin: EdgeInsets.only(left: 12, right: 150),
                          margin: orientation == Orientation.portrait
                              ? EdgeInsets.only(left: height * 0.02, right: height * 0.25)
                              : EdgeInsets.only(
                                  left: width * 0.02, right: width * 0.725),
                          child: AccountTextField(
                            fieldDecorator: kZipcodeField,
                            save: accountForm.zipcodeSave,
                            validate: accountForm.zipcodeValidate,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        textField: true,
                        label: "ZIP Code",
                        hint: "Enter your ZIP Code"),
                    Padding(
                      padding: orientation == Orientation.portrait
                          ? EdgeInsets.only(top: height * 0.035)
                          : EdgeInsets.only(top: width * 0.04),
                    ),
                    Semantics(
                        child: RaisedButton(
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: orientation == Orientation.portrait ? height * 0.04 : width * 0.05,
                            ),
                          ),
                          onPressed: () {
                            if (widget._formKey.currentState.validate()) {
                              widget._formKey.currentState.save();
                              accountForm.user.latitude = locationData.latitude;
                              accountForm.user.longitude =
                                  locationData.longitude;

                              Navigator.of(context).pop(accountForm.user);
                            }
                          },
                        ),
                        button: true,
                        label: "Submit",
                        hint: "Submit"),
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
