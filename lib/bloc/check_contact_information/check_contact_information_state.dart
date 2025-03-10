part of 'check_contact_information_bloc.dart';

sealed class CheckContactInformationState extends Equatable {
  const CheckContactInformationState();

  @override
  List<Object> get props => [];
}

final class CheckContactInformationInitial extends CheckContactInformationState {}

final class CheckContactInformationLoading extends CheckContactInformationState {}

final class CheckContactInformationSuccess extends CheckContactInformationState {
  final String message;

  const CheckContactInformationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class CheckContactInformationFailure extends CheckContactInformationState {
  final String message;

  const CheckContactInformationFailure(this.message);

  @override
  List<Object> get props => [message];
}
