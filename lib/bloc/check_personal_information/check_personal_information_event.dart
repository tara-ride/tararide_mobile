part of 'check_personal_information_bloc.dart';

sealed class CheckPersonalInformationEvent extends Equatable {
  const CheckPersonalInformationEvent();

  @override
  List<Object> get props => [];
}

final class CheckPersonalInformationAwaiting extends CheckPersonalInformationEvent {}

final class CheckPersonalInformationSubmit extends CheckPersonalInformationEvent {
  final String firstName;
  final String? middleName;
  final String lastName;
  final DateTime birthDate;

  const CheckPersonalInformationSubmit({required this.firstName, required this.lastName, required this.birthDate, required this.middleName});

  String get getFirstName => firstName;
  String get getMiddleName => middleName!;
  String get getLastName => lastName;
  DateTime get getBirthDate => birthDate;
  
  @override
  List<Object> get props => [firstName, lastName, birthDate, middleName!];
}
