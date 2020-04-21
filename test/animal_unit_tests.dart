import 'package:test/test.dart';
import '../lib/models/animal.dart';

void main() {
  test('New Animal objects have properly assigned values', () {
    String name = 'Rover';
    String animalType = 'Dog';
    String breed = 'Beagle';
    String sex = 'Male';
    String dateOfBirth = '2020-01-01';
    String adoptionStatus = 'Available';
    String shelterName = 'Chicago Humane Society';
    double latitude = 41.8781;
    double longitude = -87.6298;
    bool goodAnimals = true;
    bool goodChildren = true;
    bool leashNeeded = true;

    var testAnimal = Animal(name: name, animalType: animalType, breed: breed, sex: sex,
              dateOfBirth: dateOfBirth, imageURL: 'https://i.ytimg.com/vi/bx7BjjqHf2U/maxresdefault.jpg',
              adoptionStatus: adoptionStatus, shelterName: shelterName,
              latitude: latitude, longitude: longitude,
              goodAnimals: goodAnimals, goodChildren: goodChildren, leashNeeded: leashNeeded);

    expect(testAnimal.name, name);
    expect(testAnimal.animalType, animalType);
    expect(testAnimal.breed, breed);
    expect(testAnimal.sex, sex);
    expect(testAnimal.dateOfBirth, dateOfBirth);
    expect(testAnimal.adoptionStatus, adoptionStatus);
    expect(testAnimal.shelterName, shelterName);
    expect(testAnimal.latitude, latitude);
    expect(testAnimal.longitude, longitude);
    expect(testAnimal.goodAnimals, goodAnimals);
    expect(testAnimal.goodChildren, goodChildren);
    expect(testAnimal.leashNeeded, leashNeeded);
  });

  test('Animal age correctly calculated (days old)', () {
    DateTime fiveDaysAgo = DateTime.now().subtract(new Duration(days: 5));
    var testAnimal = Animal(dateOfBirth: fiveDaysAgo.toString().substring(0, 10));

    expect(testAnimal.getAge(), "5 Days");
  });

  test('Animal age correctly calculated (weeks old)', () {
    DateTime tenWeeksAgo = DateTime.now().subtract(new Duration(days: 75));
    var testAnimal = Animal(dateOfBirth: tenWeeksAgo.toString().substring(0, 10));

    expect(testAnimal.getAge(), "10 Weeks");
  });

  test('Animal age correctly calculated (months old)', () {
    DateTime now = DateTime.now();

    int dobDay = now.day;
    int dobMonth = now.month < 8 ? 12 - (8 - now.month) : now.month - 8;
    int dobYear = now.month < 8 ? now.year - 1 : now.year;
    String dayString = dobDay < 10 ? '0' + dobDay.toString() : dobDay.toString();
    String monthString = dobMonth < 10 ? '0' + dobMonth.toString() : dobMonth.toString();
    String dateString = dobYear.toString() + '-' + monthString + '-' + dayString;

    var testAnimal = Animal(dateOfBirth: dateString);
    expect(testAnimal.getAge(), "8 Months");
  });

  test('Animal age correctly calculated (years old & birth month is before current month)', () {
    DateTime now = DateTime.now();

    int dobDay = now.day;
    int dobMonth = now.month + 2;
    int dobYear = now.year - 1;
    String dayString = dobDay < 10 ? '0' + dobDay.toString() : dobDay.toString();
    String monthString = dobMonth < 10 ? '0' + dobMonth.toString() : dobMonth.toString();
    String dateString = dobYear.toString() + '-' + monthString + '-' + dayString;

    var testAnimal = Animal(dateOfBirth: dateString);
    expect(testAnimal.getAge(), "10 Months");
  });

  test('Animal age correctly calculated (years old & birth month is after current month)', () {
    DateTime now = DateTime.now();

    int dobDay = now.day;
    int dobMonth = now.month - 2;
    int dobYear = now.year - 1;
    String dayString = dobDay < 10 ? '0' + dobDay.toString() : dobDay.toString();
    String monthString = dobMonth < 10 ? '0' + dobMonth.toString() : dobMonth.toString();
    String dateString = dobYear.toString() + '-' + monthString + '-' + dayString;

    var testAnimal = Animal(dateOfBirth: dateString);
    expect(testAnimal.getAge(), "1 Year 2 Months");
  });

  test('Animal age correctly calculated (takes into consideration day of the month)', () {
    DateTime now = DateTime.now();

    int dobDay = now.day + 2;
    int dobMonth = now.month + 2;
    int dobYear = now.year - 1;
    String dayString = dobDay < 10 ? '0' + dobDay.toString() : dobDay.toString();
    String monthString = dobMonth < 10 ? '0' + dobMonth.toString() : dobMonth.toString();
    String dateString = dobYear.toString() + '-' + monthString + '-' + dayString;

    var testAnimal = Animal(dateOfBirth: dateString);
    expect(testAnimal.getAge(), "9 Months");
  });
}