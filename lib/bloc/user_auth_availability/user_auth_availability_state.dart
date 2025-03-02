part of 'user_auth_availability_bloc.dart';

abstract class UserAuthAvailabilityState extends Equatable {
  const UserAuthAvailabilityState();

  @override
  List<Object> get props => [];
}

final class UserAuthAvailabilityInitial extends UserAuthAvailabilityState {}

// ignore: must_be_immutable
final class UserAvailable extends UserAuthAvailabilityState {
  User user;

  UserAvailable({required this.user});

  @override
  List<Object> get props => [user];
}

final class UserNotAvailable extends UserAuthAvailabilityState {}

final class UserAuthAvailabilityError extends UserAuthAvailabilityState {
  final String errorMessage;

  const UserAuthAvailabilityError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
