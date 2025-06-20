import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tararide_mobile/models/passenger.dart';

part 'user_sign_up_event.dart';
part 'user_sign_up_state.dart';

class UserSignUpBloc extends Bloc<UserSignUpEvent, UserSignUpState> {
  UserSignUpBloc() : super(UserSignUpInitial()) {
    on<SignUpAwaiting>(
      (event, emit) {
        emit(UserSignUpInitial());
      },
    );
    on<SignUpUser>(
      (event, emit) async {
        try {
          FirebaseAuth firebaseAuth = FirebaseAuth.instance;

          // Call the API to sign up the user
          // If the API call is successful, emit UserSignUpSuccess
          // If the API call is unsuccessful, emit UserSignUpFailure
          emit(UserSignUpLoading());
          await Future.delayed(const Duration(seconds: 1));
          UserCredential? firebaseUserCredential = await firebaseAuth.createUserWithEmailAndPassword(email: event.email, password: event.password);
          if (firebaseUserCredential.user != null) {
            //emit(UserSignUpSuccess());
            //process account information
            //process personal information
            //process contact information

            FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
            FirebaseStorage firebaseStorage = FirebaseStorage.instance;
            await firebaseFirestore.collection("account_information").doc(firebaseUserCredential.user!.uid).set({
              "business_role": "passenger",
              "created_by": "tararide_automated_service",
              "created_on": DateTime.now(),
              "email_address": firebaseUserCredential.user!.email,
              "current_location": const GeoPoint(0, 0),
              "status": "idle",
              "ride_id": "",
              "uuid": firebaseUserCredential.user!.uid,
            });
            DocumentSnapshot<Map<String, dynamic>> accountData = await firebaseFirestore.collection("account_information").doc(firebaseUserCredential.user!.uid).get();

            await firebaseFirestore.collection("personal_information").doc(firebaseUserCredential.user!.uid).set({
              "first_name": event.firstName,
              "middle_name": event.middleName!,
              "last_name": event.lastName,
              "sex_at_birth": event.sexAtBirth,
              "birth_date": event.birthDate,
            });
            DocumentSnapshot<Map<String, dynamic>> personalData = await firebaseFirestore.collection("personal_information").doc(firebaseUserCredential.user!.uid).get();

            await firebaseFirestore.collection("contact_information").doc(firebaseUserCredential.user!.uid).set({
              "contact_no": event.contactNo,
              "home_address": event.homeAddress,
            });
            DocumentSnapshot<Map<String, dynamic>> contactData = await firebaseFirestore.collection("contact_information").doc(firebaseUserCredential.user!.uid).get();

            //FirebaseStorage firebaseStorage = FirebaseStorage.instance;

            if (accountData.exists && personalData.exists && contactData.exists) {
              emit(UserSignUpSuccess());
            } else {
              emit(const UserSignUpError("Unable to upload user data."));
            }
          } else {
            emit(const UserSignUpError("Unable to fetch user data."));
          }
          //emit(UserSignUpSuccess());
          //emit(UserSignUpFailure());
        } catch (e) {
          emit(UserSignUpError(e.toString()));
        }
      },
    );
  }
}
