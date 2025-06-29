part of 'user_profile_bloc.dart';

sealed class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

final class UserProfileInitial extends UserProfileState {}

final class UserProfileLoaded extends UserProfileState {
  final AccountInformationModel accountInformation;
  final PersonalInformationModel personalInformation;
  final ContactInformationModel contactInformation;

  const UserProfileLoaded({required this.accountInformation, required this.personalInformation, required this.contactInformation});
  @override
  List<Object> get props => [accountInformation, personalInformation, contactInformation];
}

final class UserProfileDisplayError extends UserProfileState {
  final String error;

  const UserProfileDisplayError({required this.error});
  @override
  List<Object> get props => [error];
}
