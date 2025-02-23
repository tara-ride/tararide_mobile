part of 'user_auth_availability_bloc.dart';

sealed class UserAuthAvailabilityEvent extends Equatable {
  const UserAuthAvailabilityEvent();

  @override
  List<Object> get props => [];
}

//create bloc events here, for initial event, we will use this event to check if user is authenticated or not
final class UserAuthAvailabilityCheck extends UserAuthAvailabilityEvent {
  @override
  List<Object> get props => [];
}

final class UserAuthInitilize extends UserAuthAvailabilityEvent {
  @override
  List<Object> get props => [];
}
