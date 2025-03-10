part of 'check_account_information_bloc.dart';

sealed class CheckAccountInformationState extends Equatable {
  const CheckAccountInformationState();

  @override
  List<Object> get props => [];
}

final class CheckAccountInformationInitial extends CheckAccountInformationState {}

final class CheckAccountInformationLoading extends CheckAccountInformationState {}

final class CheckAccountInformationSuccess extends CheckAccountInformationState {
  final String message;

  const CheckAccountInformationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class CheckAccountInformationFailure extends CheckAccountInformationState {
  final String error;

  const CheckAccountInformationFailure(this.error);

  @override
  List<Object> get props => [error];
}
