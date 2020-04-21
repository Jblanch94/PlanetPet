class Animal {
  String name;
  DateTime creationDate = DateTime.now();
  String animalType;
  String breed;
  String sex;
  String dateOfBirth;
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
          this.sex = 'Male', this.dateOfBirth = '2001-01-01', this.imageURL = 'NULL',
          this.adoptionStatus = 'Available', this.shelterName = 'Hope Animal Shelter',
          this.latitude = 100.0, this.longitude = 100.0, this.goodAnimals = true,
          this.goodChildren = true, this.leashNeeded = true});

  DateTime get dobToDate => DateTime.parse(dateOfBirth);

  String getAge() {
    String ageString = "";

    DateTime now = DateTime.now();
    Duration age = now.difference(dobToDate);

    // if the animal is less than 1 week old report the age in Days
    if (age.inDays < 7) {
      ageString = age.inDays.toString() + " Days";

    // if the animal is less than 5 months old report the age in Weeks
    } else if (age.inDays < 150) {
      int ageInWeeks = (age.inDays / 7).round();
      ageString = ageInWeeks > 1 ? ageInWeeks.toString() + " Weeks" : ageInWeeks.toString() + " Week";

    // if the animal is older than 5 months report the age in Years & Months
    } else {
      int dobDay = dobToDate.day;
      int dobMonth = dobToDate.month;
      int dobYear = dobToDate.year;

      int currentDay = now.day;
      int currentMonth = now.month;
      int currentYear = now.year;

      int ageInYears = currentYear - dobYear;
      int ageInMonths = currentMonth > dobMonth ? currentMonth - dobMonth : 12 + currentMonth - dobMonth;
      if (currentMonth < dobMonth) { ageInYears--; }
      if (currentDay > dobDay) { ageInMonths--; }

      if (ageInYears != 0) {
        ageString = ageInYears > 1 ? ageInYears.toString() + " Years " : ageInYears.toString() + " Year ";
      }
      ageString += ageInMonths > 1 ? ageInMonths.toString() + " Months" : ageInMonths.toString() + " Month";
    }

    return ageString;

  }

}