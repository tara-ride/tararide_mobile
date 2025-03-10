import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_auth_availability_event.dart';
part 'user_auth_availability_state.dart';

class UserAuthAvailabilityBloc extends Bloc<UserAuthAvailabilityEvent, UserAuthAvailabilityState> {
  UserAuthAvailabilityBloc() : super(UserAuthAvailabilityInitial()) {
    on<UserAuthInitilize>(
      (event, emit) => emit(UserAuthAvailabilityInitial()),
    );
    on<UserAuthAvailabilityCheck>((event, emit) async {
      //check if user is authenticated or not
      try {
        var firebaseAuthCurrentUser = FirebaseAuth.instance.currentUser;
        if (firebaseAuthCurrentUser != null) {
          emit(UserAvailable(user: firebaseAuthCurrentUser));
        } else {
          emit(UserNotAvailable());
        }
      } catch (e) {
        emit(UserAuthAvailabilityError(errorMessage: e.toString()));
      }
    });
  }
}
