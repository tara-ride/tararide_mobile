class PersonalInformationModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String middleName;
  final DateTime birthDate;
  String? profilePicImage;
  final String sexAtBirth;

  PersonalInformationModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.birthDate,
    required this.profilePicImage,
    required this.sexAtBirth,
  });

  factory PersonalInformationModel.fromJson(Map<String, dynamic> json) {
    return PersonalInformationModel(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      middleName: json['middle_name'] as String,
      birthDate: DateTime.parse(json["birth_date"].toDate().toString()),
      profilePicImage: json['profilePicImage'],
      sexAtBirth: json['sex_at_birth'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName,
      'birth_date': birthDate.toIso8601String(),
      'profilePicImage': profilePicImage,
      'sex_at_birth': sexAtBirth,
    };
  }
}
