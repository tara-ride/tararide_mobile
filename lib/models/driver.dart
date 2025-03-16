import 'package:tararide_mobile/models/firebase_user.dart';

class Driver extends FirebaseUserDetails {
  String _currentStatus;
  String _driverCurrentStatus;

  String _verificationStatus;
  String _homeAddress;
  String _imagePath;
  String _plateNo;
  DateTime _dateRegistered;
  DateTime _lastLoginDate;
  String _driversLicense;
  String _emailAddress;
  String _contactNumber;

  // Constructor
  Driver({
    required String currentStatus,
    required String driverCurrentStatus,
    required String verificationStatus,
    required String homeAddress,
    required String imagePath,
    required String plateNo,
    required DateTime dateRegistered,
    required DateTime lastLoginDate,
    required String driversLicense,
    required String emailAddress,
    required String contactNumber,
    required super.firstName,
    required super.middleName,
    required super.lastName,
    required super.sexAtBirth,
    required super.birthDate,
  })  : _currentStatus = currentStatus,
        _driverCurrentStatus = driverCurrentStatus,
        _verificationStatus = verificationStatus,
        _homeAddress = homeAddress,
        _imagePath = imagePath,
        _plateNo = plateNo,
        _dateRegistered = dateRegistered,
        _lastLoginDate = lastLoginDate,
        _driversLicense = driversLicense,
        _emailAddress = emailAddress,
        _contactNumber = contactNumber;
  // Getters and Setters
  String get getCurrentStatus => _currentStatus;
  set currentStatus(String value) => _currentStatus = value;

  String get getDriverCurrentStatus => _driverCurrentStatus;
  set setDriverCurrentStatus(String value) => _driverCurrentStatus = value;

  String get getVerificationStatus => _verificationStatus;
  set setVerificationStatus(String value) => _verificationStatus = value;

  String get getHomeAddress => _homeAddress;
  set setHomeAddress(String value) => _homeAddress = value;

  String get getImagePath => _imagePath;
  set setImagePath(String value) => _imagePath = value;

  String get getPlateNo => _plateNo;
  set setPlateNo(String value) => _plateNo = value;

  DateTime get getDateRegistered => _dateRegistered;
  set setDateRegistered(DateTime value) => _dateRegistered = value;

  DateTime get getLastLoginDate => _lastLoginDate;
  set setLastLoginDate(DateTime value) => _lastLoginDate = value;

  String get getDriversLicense => _driversLicense;
  set setDriversLicense(String value) => _driversLicense = value;

  String get getEmailAddress => _emailAddress;
  set setEmailAddress(String value) => _emailAddress = value;

  String get getContactNumber => _contactNumber;
  set setContactNumber(String value) => _contactNumber = value;
}
