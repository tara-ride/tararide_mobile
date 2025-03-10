part of 'check_contact_information_bloc.dart';

sealed class CheckContactInformationEvent extends Equatable {
  const CheckContactInformationEvent();

  @override
  List<Object> get props => [];
}

final class CheckContactInformationAwaiting extends CheckContactInformationEvent {}

final class CheckContactInformation extends CheckContactInformationEvent {}
