
class Passenger {
  String _currentBooking;
  String _firstName;
  String _middleName;
  String _lastName;
  DateTime _birthDate;
  String _emailAddress;
  String _contactNo;
  String _homeAddress;

  Passenger(
    this._currentBooking,
    this._firstName,
    this._middleName,
    this._lastName,
    this._birthDate,
    this._emailAddress,
    this._contactNo,
    this._homeAddress,
  );

  String get getCurrentBooking => _currentBooking;
  set setCurrentBooking(String currentBooking) => _currentBooking = currentBooking;

  String get getFirstName => _firstName;
  set setFirstName(String firstName) => _firstName = firstName;

  String get getMiddleName => _middleName;
  set setMiddleName(String middleName) => _middleName = middleName;

  String get getLastName => _lastName;
  set setLastName(String lastName) => _lastName = lastName;

  DateTime get getBirthDate => _birthDate;
  set setBirthDate(DateTime birthDate) => _birthDate = birthDate;

  String get getEmailAddress => _emailAddress;
  set setEmailAddress(String emailAddress) => _emailAddress = emailAddress;

  String get getContactNo => _contactNo;
  set setContactNo(String contactNo) => _contactNo = contactNo;

  String get getHomeAddress => _homeAddress;
  set setHomeAddress(String homeAddress) => _homeAddress = homeAddress;
}