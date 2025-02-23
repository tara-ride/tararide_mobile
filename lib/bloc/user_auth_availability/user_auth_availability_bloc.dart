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
    on<UserAuthAvailabilityCheck>((event, emit) {
      //check if user is authenticated or not
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          //if user is authenticated, emit UserAuthAvailabilityAuthenticated
          print("User authenticated $user");
          emit(UserAvailable(userDisplayName: user.displayName ?? "nullified", userEmail: user.email ?? "nullified"));
        } else {
          print("User not available");
          emit(UserNotAvailable());
        }
      });
    });
  }
}
