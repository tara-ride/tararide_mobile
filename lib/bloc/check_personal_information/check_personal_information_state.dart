part of 'check_personal_information_bloc.dart';

sealed class CheckPersonalInformationState extends Equatable {
  const CheckPersonalInformationState();

  @override
  List<Object> get props => [];
}

final class CheckPersonalInformationInitial extends CheckPersonalInformationState {}

final class CheckPersonalInformationLoading extends CheckPersonalInformationState {}

final class CheckPersonalInformationSuccess extends CheckPersonalInformationState {
  final String message;

  const CheckPersonalInformationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class CheckPersonalInformationFailure extends CheckPersonalInformationState {
  final String error;

  const CheckPersonalInformationFailure(this.error);

  @override
  List<Object> get props => [error];
}
