part of 'user_sign_up_bloc.dart';

sealed class UserSignUpEvent extends Equatable {
  const UserSignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpAwaiting extends UserSignUpEvent {}

final class SignUpUser extends UserSignUpEvent {
  //account_information
  final String email;
  final String password;

  //personal_information
  final String firstName;
  final String? middleName;
  final String lastName;
  final String sexAtBirth;
  final DateTime birthDate;

  //contact_information
  final String contactNo;
  final String homeAddress;

  const SignUpUser({required this.email, required this.password, required this.firstName, required this.middleName, required this.lastName, required this.sexAtBirth, required this.birthDate, required this.contactNo, required this.homeAddress});

  List<Object> get props => [email, password, firstName, middleName!, lastName, sexAtBirth, birthDate, contactNo, homeAddress];
}
