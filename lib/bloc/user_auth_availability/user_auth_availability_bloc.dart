import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

    on<UserAuthContinue>((event, emit) async {
      try {
        var firebaseAuthCurrentUser = FirebaseAuth.instance.currentUser;
        if (firebaseAuthCurrentUser != null) {
          FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
          DocumentReference<Map<String, dynamic>> accountInformationDocumentReference = firebaseFirestore.collection("account_information").doc(firebaseAuthCurrentUser.uid);
          DocumentSnapshot<Map<String, dynamic>> accountInformationDocumentSnapshot = await accountInformationDocumentReference.get();
          if (accountInformationDocumentSnapshot.data() != null) {
            emit(UserAuthComplete(userData: accountInformationDocumentSnapshot.data()!));
          } else {
            emit(const UserAuthAvailabilityError(errorMessage: "Failed to receive user data."));
          }
        } else {
          emit(const UserAuthAvailabilityError(errorMessage: "User not recognized in the system."));
        }
      } catch (err) {
        emit(UserAuthAvailabilityError(errorMessage: err.toString()));
      }
    });
  }
}
