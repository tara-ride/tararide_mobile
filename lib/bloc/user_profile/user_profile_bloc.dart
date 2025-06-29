import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tararide_mobile/models/account_information.dart';
import 'package:tararide_mobile/models/contact_information.dart';
import 'package:tararide_mobile/models/personal_information.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileInitial()) {
    on<LoadUserProfile>((event, emit) async {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      print("event : event.userId ${event.userId}");
      if (firebaseAuth.currentUser != null) {
        var accountInformationReference = firebaseFirestore.collection("account_information").doc(event.userId);
        var personalInformationReference = firebaseFirestore.collection("personal_information").doc(event.userId);
        var contactInformationReference = firebaseFirestore.collection("contact_information").doc(event.userId);

        var accountDocument = await accountInformationReference.get();
        var personalInfoDocument = await personalInformationReference.get();
        var contactInfoDocument = await contactInformationReference.get();

        if (accountDocument.exists && contactInfoDocument.exists && personalInfoDocument.exists) {
          //
          final accountInformation = AccountInformationModel.fromJson(accountDocument.data() as Map<String, dynamic>);
          final personalInformation = PersonalInformationModel.fromJson(personalInfoDocument.data() as Map<String, dynamic>);
          final contactInformation = ContactInformationModel.fromJson(contactInfoDocument.data() as Map<String, dynamic>);

          add(DisplayUserProfile(accountInformation: accountInformation, contactInformation: contactInformation, personalInformation: personalInformation));
        } else {
          emit(const UserProfileDisplayError(error: "Cannot fetch data from the database."));
        }
      }
    });

    on<DisplayUserProfile>((event, emit) {
      emit(UserProfileLoaded(accountInformation: event.accountInformation, personalInformation: event.personalInformation, contactInformation: event.contactInformation));
    });

    on<DisplayUserProfileError>((event, emit) {
      emit(UserProfileDisplayError(error: event.error));
    });

    on<UserProfileInitialize>((event, emit) {
      emit(UserProfileInitial());
    });
  }
}
