part of 'user_auth_availability_bloc.dart';

abstract class UserAuthAvailabilityState extends Equatable {
  const UserAuthAvailabilityState();

  @override
  List<Object> get props => [];
}

final class UserAuthAvailabilityInitial extends UserAuthAvailabilityState {}

final class UserAvailable extends UserAuthAvailabilityState {
  String userDisplayName;
  String userEmail;

  UserAvailable({required this.userDisplayName, required this.userEmail});

  @override
  List<Object> get props => [userDisplayName, userEmail];
}

final class UserNotAvailable extends UserAuthAvailabilityState {}
