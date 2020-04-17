class Animal {
  String name;
  DateTime dateOfBirth = DateTime.parse('2010-01-01');
  DateTime creationDate = DateTime.now();
  String animalType;
  String breed;
  String sex;
  String imageURL;

  String adoptionStatus;
  String shelterName;
  double latitude;
  double longitude;

  bool goodAnimals;
  bool goodChildren;
  bool leashNeeded;

  var matchedUsers = new List();

  Animal({this.name = 'Fido', this.animalType = 'Dog', this.breed = 'Golden Retriever',
          this.sex = 'Male', this.imageURL = 'NULL', this.adoptionStatus = 'Available',
          this.shelterName = 'Hope Animal Shelter', this.latitude = 100.0, this.longitude = 100.0,
          this.goodAnimals = true, this.goodChildren = true, this.leashNeeded = true});

  void setDateOfBirth(DateTime date){
    this.dateOfBirth = date;
  }


}