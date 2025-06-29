part of 'user_profile_bloc.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends UserProfileEvent {
  final String userId;

  const LoadUserProfile({required this.userId});
  @override
  List<Object> get props => [userId];
}

class UserProfileInitialize extends UserProfileEvent {
  @override
  List<Object> get props => [];
}

class DisplayUserProfileError extends UserProfileEvent {
  final String error;

  const DisplayUserProfileError({required this.error});
  @override
  List<Object> get props => [error];
}

class DisplayUserProfile extends UserProfileEvent {
  final AccountInformationModel accountInformation;
  final PersonalInformationModel personalInformation;
  final ContactInformationModel contactInformation;

  const DisplayUserProfile({required this.accountInformation, required this.contactInformation, required this.personalInformation});
  @override
  List<Object> get props => [accountInformation, personalInformation, contactInformation];
}
