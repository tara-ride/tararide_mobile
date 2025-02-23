import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_auth_availability_event.dart';
part 'user_auth_availability_state.dart';

class UserAuthAvailabilityBloc extends Bloc<UserAuthAvailabilityEvent, UserAuthAvailabilityState> {
  UserAuthAvailabilityBloc() : super(UserAuthAvailabilityInitial()) {
    on<UserAuthAvailabilityEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
