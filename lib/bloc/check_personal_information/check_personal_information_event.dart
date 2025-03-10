part of 'check_personal_information_bloc.dart';

sealed class CheckPersonalInformationEvent extends Equatable {
  const CheckPersonalInformationEvent();

  @override
  List<Object> get props => [];
}

final class CheckPersonalInformationAwaiting extends CheckPersonalInformationEvent {}

final class CheckPersonalInformationSubmit extends CheckPersonalInformationEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String address;

  const CheckPersonalInformationSubmit(this.name, this.email, this.phoneNumber, this.address);

  @override
  List<Object> get props => [name, email, phoneNumber, address];
}
