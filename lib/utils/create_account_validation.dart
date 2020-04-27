import 'package:planet_pet/models/user.dart';

class AccountFormValidation {
  User user = User();
  String phoneValidate(String value) {
    if (value.trim().length != 10) {
      return 'Invalid phone Number';
    }
    return null;
  }

  String streetAddress1Validate(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter a valid address';
    }
    return null;
  }

  String cityValidate(String value) {
    if (value.trim().length < 3) {
      return 'Please enter a valid city';
    }
    return null;
  }

  String zipcodeValidate(String value) {
    if (value.trim().length < 5) {
      return 'Please enter a valid zip code';
    }
    return null;
  }

  void phoneSave(String value) {
    user.phoneNumber = value;
  }

  void streetAddress1Save(String value) {
    user.streetAddress1 = value;
  }

  void streetAddress2Save(String value) {
    if (value.trim().isEmpty) {
      user.streetAddress2 = '';
    } else {
      user.streetAddress2 = value;
    }
  }

  void citySave(String value) {
    user.city = value;
  }

  void zipcodeSave(String value) {
    user.zipcode = value;
  }

  //create list of states
  List<String> states = [
    'AL',
    'AK',
    'AZ',
    'AR',
    'CA',
    'CO',
    'CT',
    'DE',
    'FL',
    'GA',
    'HI',
    'ID',
    'IL',
    'IN',
    'IA',
    'KS',
    'KY',
    'LA',
    'ME',
    'MD',
    'MA',
    'MI',
    'MN',
    'MS',
    'MO',
    'MT',
    'NE',
    'NV',
    'NH',
    'NJ',
    'NM',
    'NY',
    'NC',
    'ND',
    'OH',
    'OK',
    'OR',
    'PA',
    'RI',
    'SC',
    'SD',
    'TN',
    'TX',
    'UT',
    'VT',
    'VA',
    'WA',
    'WV',
    'WI',
    'WY'
  ];
}
