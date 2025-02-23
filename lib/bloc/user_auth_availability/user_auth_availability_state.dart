part of 'user_auth_availability_bloc.dart';

sealed class UserAuthAvailabilityState extends Equatable {
  const UserAuthAvailabilityState();
  
  @override
  List<Object> get props => [];
}

final class UserAuthAvailabilityInitial extends UserAuthAvailabilityState {}
