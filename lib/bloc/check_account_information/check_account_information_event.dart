part of 'check_account_information_bloc.dart';

sealed class CheckAccountInformationEvent extends Equatable {
  const CheckAccountInformationEvent();

  @override
  List<Object> get props => [];
}

final class CheckAccountInformationAwaiting extends CheckAccountInformationEvent {}

final class CheckAccountInformation extends CheckAccountInformationEvent {
  final String email;
  final String password;
  final String retypePassword;

  const CheckAccountInformation(this.email, this.password, this.retypePassword);

  @override
  List<Object> get props => [email, password];
}
